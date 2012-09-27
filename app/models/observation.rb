require 'csv'

class Observation < ActiveRecord::Base
  include ImportHandler
  
  include AssistShared::CSV::Observation
  include AssistShared::Validations::Observation
  
  has_one  :ice, :dependent => :destroy
  has_many :photos, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :ice_observations, :dependent => :destroy do
    def obs_type o
      o = o.to_sym
      ice = where(:obs_type => o).first
      ice
    end
    def primary
      obs_type :primary
    end
    def secondary
      obs_type :secondary
    end
    def tertiary
      obs_type :tertiary
    end
  end
  has_one  :meteorology, :dependent => :destroy
  has_many :observation_users
  belongs_to :primary_observer, :class_name => "User"
  has_many :additional_observers, :through => :observation_users, :class_name => "User", :source => :user


  before_create do |obs|
    begin
      obs.uuid = SecureRandom.uuid
    end while Observation.where(uuid: obs.uuid).any?
    
    obs.ice = Ice.new if obs.ice.nil?
    obs.meteorology = Meteorology.new if obs.meteorology.nil?
    %w(primary secondary tertiary).each do |obs_type|
      if(obs.ice_observations.obs_type(obs_type).nil?)
        obs.ice_observations << IceObservation.new(:obs_type => obs_type)
      end
    end
  end    

  accepts_nested_attributes_for :ice
  accepts_nested_attributes_for :ice_observations
  accepts_nested_attributes_for :meteorology
  accepts_nested_attributes_for :photos

  before_save do
    self.latitude = self.to_dd(latitude) if latitude =~ /^(\+|-)?[0-9]{1,2}\s[0-9]{1,2}(\.[0-9]{1,2})?(\s?[NS])?$/
    self.longitude = self.to_dd(longitude) if longitude =~ /^(\+|-)?[0-9]{1,3}\s[0-9]{1,2}(\.[0-9]{1,2})?(\s?[EW])?$/
    self.hexcode = Digest::MD5.hexdigest("#{obs_datetime}#{latitude}#{longitude}#{primary_observer.try(&:first_and_last_name)}")
  end


  def to_dd dms
    deg,ms = dms.split " "
    min,sec = ms.split "."
    dec = (min.to_i * 60 + sec.to_i) / 3600.0
    dd = deg.to_i > 0 ? "#{(deg.to_i+dec)}" : "#{deg.to_i - dec}"
    dd.to_f.round(4)
  end


  def self.from_csv csv, map = "import_map.yml"
    count = 0
    errors = Array.new

    if map.is_a? String
      map = ::YAML.load_file map
    end

    if csv.is_a? String
      csv = ::CSV.open csv, {:headers => true, :return_headers => false}
    end

    unknownObserver = User.find_or_create_by_firstname_and_lastname(map[:user][:first_name], map[:user][:last_name])
      
    csv.each do |row|
      next if row.empty?
 
      data = parse_csv(row,map)
      begin
        date = data[:date]
        obs_datetime = DateTime.parse( ERB.new(date[:parse]).result(binding) )
      rescue => e
        logger.info("Invalid date #{date.inspect}")
      end
      if data[:observation][:primary_observer_id].nil?
        data[:observation][:primary_observer_id] = unknownObserver.id
      else
        name = data[:observation][:primary_observer_id].split " "
        user = User.find_or_create_by_firstname_and_lastname(name.first, name.last)
        data[:observation][:primary_observer_id] = user.id
      end

      observation = Observation.import(data[:observation])
      observation.obs_datetime = obs_datetime
   
      if(observation.save)
        count += 1
      else
        errors << observation.errors
      end
    end

    {:count => count, :errors => errors}
  end

  def self.from_json jsonFile 
    count = 0
    errors = Array.new

    data = JSON.parse(File.read(jsonFile))
    [data].flatten.each do |obs|
      obs = ActiveSupport::JSON.decode(obs).symbolize_keys!
      primary= obs.delete(:primary_observer)
      additional = obs.delete(:additional_observers)
      observation = Observation.import(obs)
      observation.primary_observer = User.where(primary).first_or_create
     # additional.each do |a|
     #   observation.additional_observers << User.where(firstname: a[:firstname], lastname: a[:lastname]).first_or_create
     # end
      if(observation.save)
        count += 1
      else 
        errors << observation.errors
      end
    end
    {count: count, errors: errors}
  end

  def self.parse_csv row, map
    data = Hash.new
    map.each do |k,v|
      if v.is_a? String
        data[k] = row.include?(v) ? row[v] : v
      elsif v.is_a? Integer
        data[k] = v
      elsif v.is_a? Hash
        data[k] = parse_csv(row, v)
      elsif v.is_a? Array
        data[k] = v.collect{|i| parse_csv(row, i) }
      else
        nil
      end
    end
    
    data
  end

  def as_json opts={}
    data = {
      obs_datetime: obs_datetime,
      primary_observer: primary_observer.as_json,
      additional_observers: additional_observers.collect{|o| o.try(&:first_and_last_name)},
      latitude: latitude,
      longitude: longitude,
      hexcode: hexcode,
      cruise_id: Cruise[:id],
      ship_name: Cruise[:ship],
      ice_attributes: ice.as_json,
      ice_observations_attributes: ice_observations.collect(&:as_json),
      meteorology_attributes: meteorology.as_json,
      photos_attributes: photos.collect(&:as_json),
      comments_attributes: comments.collect(&:as_json)
    }
    data = lookup_id_to_code(data)
    data
  end

  def lookup_id_to_code(hash) 
    hash.inject(Hash.new) do |h, (k,v)|
      key = k.to_s.gsub(/lookup_id$/, "lookup_code")
    
      case v.class.to_s
      when "Hash"
        h[key] = lookup_id_to_code(v)
      when "Array"
        h[key] = v.collect{|item| item.is_a?(Hash) ? lookup_id_to_code(item) : item } 
      else
        #If it's a lookup and not nil, convert it into a code
        if(key =~ /lookup_code$/ and !!v)
          #Use where instead of find. If any bad values got injected it will turn them into nil
          v = key.chomp("_code").camelcase.constantize.where(id: v).first.try(&:code)
        end
        h[key] = v
      end
      h
    end
  end

  def zip!
    FileUtils.mkdir(path) unless File.exists?(path)
    FileUtils.remove(File.join(path, "#{name}.zip")) if File.exists?(File.join(path,"#{name}.zip"))
    dump!([:csv,:json])
    files = Dir.glob(File.join(path, "*")).collect!{|f| File.basename(f)}

    Zip::ZipFile.open(File.join(path, "#{name}.zip"), Zip::ZipFile::CREATE) do |zipfile|
      files.each do |f|
        zipfile.add(f, File.join(path,f))
      end
    end
  end

  def self.zip! observations, params={}
    name = params[:name] || "observations"
    
    FileUtils.remove(File.join(path,"#{name}.zip")) if File.exists?(File.join(path,"#{name}.zip"))

    metadata = {
      exported_on: Time.now.utc,
      assist_version: ASSIST_VERSION,
      cruise_id: Cruise[:id],
      ship_name: Cruise[:ship],
      observation_count: observations.count,
      observations: "#{name}.json",
      photos_included: !!params[:include_photos]
    }

    files = dump!([:csv, :json])
    observations.each do |o|
      files << o.dump!([:csv, :json])
    end
    
    Zip::ZipFile.open(File.join(path, "#{name}.zip"), Zip::ZipFile::CREATE) do |zipfile|
      #Add the metadata
      zipfile.file.open("METADATA", "w"){|f| f.puts metadata.to_yaml}
      logger.info(files);
      files.flatten.each do |f|
        zipfile.add(File.basename(f), f)
      end
      if params[:include_photos]
        observations.each do |o|
          o.photos.each do |p|
            zipfile.add(File.join(p.observation.name,p.name), File.join( p.observation.path, p.name))
          end
        end
      end
    end
  end

  def dump!(formats)
    FileUtils.mkdir(path) unless File.exists?(path)
    files = []
    [formats].flatten.each do |format|
      file = File.join(path,"#{name}.#{format.to_s}")
      File.open(file,"w") do |f|
        f << self.send("to_#{format.to_s}")
      end
      files << file
    end
    files
  end

  def self.dump!(formats)
    FileUtils.mkdir(path) unless File.exists?(path)
    files = []
    [formats].flatten.each do |format|
      file = File.join(path,"#{Cruise[:id]}.observations.#{format.to_s}")
      File.open(file,"w") do |f|
        f << Observation.send("to_#{format.to_s}")
      end
      files << file
    end
    files
  end

  def name 
    obs_datetime.try(:strftime, "%Y.%m.%d-%H.%M") || "INVALID_OBSERVATION_#{self.id}"
  end
  
  def path 
    "#{EXPORT_DIR}/#{self.uuid}"
  end
  
  def self.path
    EXPORT_DIR
  end

end
