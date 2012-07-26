require 'csv'

class Observation < ActiveRecord::Base
  include ImportHandler
  
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


  after_create do |obs|
    obs.ice = Ice.create if obs.ice.nil? 
    obs.meteorology = Meteorology.create if obs.meteorology.nil?
    %w(primary secondary tertiary).each do |obs_type|
        if(obs.ice_observations.obs_type(obs_type).nil?)
          obs.ice_observations << IceObservation.create(:obs_type => obs_type)
        end
    end
  end    

  accepts_nested_attributes_for :ice
  accepts_nested_attributes_for :ice_observations
  accepts_nested_attributes_for :meteorology
  accepts_nested_attributes_for :photos

  validates_presence_of :primary_observer_id, :if => :active_or_finalized?
  validates_presence_of :obs_datetime, :message => "Invalid or no date given", :if => :active_or_finalized?
  validates_presence_of :hexcode, :if => :active_or_finalized?
  validates_uniqueness_of :hexcode, :if => :active_or_finalized?

  #Allow DD or DM(S)
  validates_format_of :latitude, :with => /^(\+|-)?[0-9]{1,2}(\s[0-9]{1,2}(\.[0-9]{1,2})?|\.[0-9]*)(\s?[NS])?$/ 
  validates_format_of :longitude, :with => /^(\+|-)?[0-9]{1,3}(\s[0-9]{1,2}(\.[0-9]{1,2})?|\.[0-9]*)(\s?[EW])?$/
  validate :location

  before_validation do
    self.latitude = self.to_dd(latitude) if latitude =~ /^(\+|-)?[0-9]{1,2}\s[0-9]{1,2}(\.[0-9]{1,2})?(\s?[NS])?$/
    self.longitude = self.to_dd(longitude) if longitude =~ /^(\+|-)?[0-9]{1,3}\s[0-9]{1,2}(\.[0-9]{1,2})?(\s?[EW])?$/
    self.hexcode = Digest::MD5.hexdigest("#{obs_datetime}#{latitude}#{longitude}#{primary_observer.try(&:first_and_last_name)}")
  end

  def active?
    self.status == 'general'
  end

  def finalized?
    self.status == 'finalized'
  end

  def active_or_finalized?
    active? || finalized?
  end

  def to_dd dms
    deg,ms = dms.split " "
    min,sec = ms.split "."
    dec = (min.to_i * 60 + sec.to_i) / 3600.0
    dd = deg.to_i > 0 ? "#{(deg.to_i+dec)}" : "#{deg.to_i - dec}"
    dd.to_f.round(4)
  end

  def location 
    errors.add(:base, "Latitude must be between -90 and 90") unless (latitude.to_f < 90 && latitude.to_f > -90)
    errors.add(:base, "Longitude must be between -180 and 180") unless (longitude.to_f < 180 && longitude.to_f > -180)
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
      
      logger.info("*************")
      logger.info(observation.meteorology.clouds.count)
      #logger.info(observation.ice_observations.primary.topography.inspect)
      logger.info("*************")
      
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

  def as_csv 
    [
      "#{obs_datetime}",
      "#{primary_observer.try(&:first_and_last_name)}",
      additional_observers.collect(&:first_and_last_name).join(";"), 
      latitude,
      longitude,
      hexcode,
      Cruise.id,
      Cruise.ship,
      ice.as_csv,
      ice_observations.collect(&:as_csv),
      meteorology.try(&:as_csv)
    ]
  end

  def to_csv
    c = CSV.generate({:headers => true}) do |csv|
      csv << Observation.headers.flatten
      csv << as_csv.flatten
    end
    c
  end

  def self.to_csv
    c = CSV.generate({:headers => true}) do |csv|
      headers = Observation.headers.flatten
      csv << headers
      Observation.all.each do |o|
        csv << o.as_csv.flatten
      end
    end
    c
  end

  def as_json opts={}
    {
      obs_datetime: obs_datetime,
      primary_observer: primary_observer.as_json,
      additional_observers: additional_observers.collect{|o| o.try(&:first_and_last_name)},
      latitude: latitude,
      longitude: longitude,
      hexcode: hexcode,
      cruise_id: Cruise.id,
      ship_name: Cruise.ship,
      ice_attributes: ice.as_json,
      ice_observations_attributes: ice_observations.collect(&:as_json),
      meteorology_attributes: meteorology.as_json,
      photos_attributes: photos.collect(&:as_json),
      comments_attributes: comments.collect(&:as_json)
    }
  end

  def self.as_json
    Observation.all.collect(&:as_json).to_json
  end

  def self.to_json
    Observation.all.collect(&:to_json).to_json
  end

  def self.headers opts={}

    headers = %w( Date PrimaryObserver AdditionalObservers LATdm LONdm Hexcode CruiseID ShipName)
    headers.map!{|h| "#{opts[:prefix]}#{h}"} if opts[:prefix]
    headers.map!{|h| "#{h}#{opts[:postfix]}"}  if opts[:postfix]

    headers.push(Ice.headers)
    %w(Primary Secondary Tertiary).each {|index| headers.push( IceObservation.headers(:prefix => index) )}
    headers.push( Meteorology.headers )
    
    headers.flatten!
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
      assist_version: "1.0",
      cruise_id: Cruise.id,
      ship_name: Cruise.ship,
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
      file = File.join(path,"#{Cruise.id}.observations.#{format.to_s}")
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
    "#{EXPORT_DIR}/#{name}"
  end
  def self.path
    EXPORT_DIR
  end


end
