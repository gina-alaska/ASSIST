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
      ice ||= create :obs_type => o
      ice.create_topography if ice.topography.nil?
      ice.create_melt_pond if ice.melt_pond.nil?
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

  accepts_nested_attributes_for :ice
  accepts_nested_attributes_for :ice_observations
  accepts_nested_attributes_for :meteorology
  accepts_nested_attributes_for :photos

  validates_presence_of :primary_observer_id
  validates_presence_of :obs_datetime, :message => "Invalid or no date given"
  validates_presence_of :hexcode
  validates_uniqueness_of :hexcode
  #Allow DD or DM(S)
  validates_format_of :latitude, :with => /^(\+|-)?[0-9]{1,2}(\s[0-9]{1,2}(\.[0-9]{1,2})?|\.[0-9]*)(\s?[NS])?$/
  validates_format_of :longitude, :with => /^(\+|-)?[0-9]{1,3}(\s[0-9]{1,2}(\.[0-9]{1,2})?|\.[0-9]*)(\s?[EW])?$/

  after_initialize do
    create_ice if ice.nil?
    create_meteorology if meteorology.nil?
  end

  before_validation do
    logger.info("Before Save")
    self.hexcode = Digest::MD5.hexdigest("#{obs_datetime}#{latitude}#{longitude}#{primary_observer_id}")
    self.latitude = self.to_dd(latitude) if latitude =~ /^(\+|-)?[0-9]{1,2}\s[0-9]{1,2}(\.[0-9]{1,2})?(\s?[NS])?$/
    self.longitude = self.to_dd(longitude) if longitude =~ /^(\+|-)?[0-9]{1,3}\s[0-9]{1,2}(\.[0-9]{1,2})?(\s?[EW])?$/
  end

  def finalized?
    #self.finalized_at
    false
  end

  def to_dd dms
    deg,ms = dms.split " "
    min,sec = ms.split "."
    dec = (min.to_i * 60 + sec.to_i) / 3600.0
    deg.to_i > 0 ? "#{deg.to_i+dec}" : "#{deg.to_i - dec}"
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
      data = parse_csv(row,map)
      begin
        date = data[:date]
        obs_datetime = DateTime.parse( ERB.new(date[:parse]).result(binding) )
      rescue => e
        logger.info("Invalid date #{data.inspect}")
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
      logger.info observation.inspect
      sleep 3
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
      obs_datetime,
      primary_observer.try(&:first_and_last_name), 
      latitude,
      longitude,
      hexcode,
      ice.as_csv,
      ice_observations.collect(&:as_csv),
      meteorology.as_csv
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
      csv << Observation.headers.flatten
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
      #additional_observers: additional_observers.collect({|o| o.try(&:first_and_last_name)}),
      latitude: latitude,
      longitude: longitude,
      hexcode: hexcode,
      ice_attributes: ice.as_json,
      ice_observations_attributes: ice_observations.collect(&:as_json),
      meteorology_attributes: meteorology.as_json
    }
  end

  def self.as_json
    Observation.all.collect(&:as_json)
  end

  def self.to_json
    Observation.all.collect(&:to_json)
  end

  def self.headers opts={}

    headers = %w( Date PrimaryObserver LATdm LONdm Hexcode)
    headers.map!{|h| "#{opts[:prefix]}#{h}"} if opts[:prefix]
    headers.map!{|h| "#{h}#{opts[:postfix]}"}  if opts[:postfix]

    headers.push(Ice.headers)
    %w(Primary Secondary Tertiary).each {|index| headers.push( IceObservation.headers(:prefix => index) )}
    headers.push( Meteorology.headers )
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

  def self.zip! name="FinalizedObservations"

    FileUtils.remove(File.join(path,"#{name}.zip")) if File.exists?(File.join(path,"#{name}.zip"))

    files = dump!([:csv, :json])
    Zip::ZipFile.open(File.join(path, "#{name}.zip"), Zip::ZipFile::CREATE) do |zipfile|
      files.each do |f|
        zipfile.add(File.basename(f), f)
      end
      Photo.all.each do |p|
        zipfile.add(File.join(p.observation.name,p.name), File.join( p.observation.path, p.name))
      end
    end
  end

  def dump!(formats)
    FileUtils.mkdir(path) unless File.exists?(path)
    [formats].flatten.each do |format|
      File.open(File.join(path, "#{name}.#{format.to_s}"),"w") do |f|
        f << self.send("to_#{format.to_s}")
      end
    end
  end

  def self.dump!(formats)
    FileUtils.mkdir(path) unless File.exists?(path)
    files = []
    [formats].flatten.each do |format|
      file = File.join(path,"observation.#{format.to_s}")
      File.open(file,"w") do |f|
        f << Observation.send("to_#{format.to_s}")
      end
      files << file
    end
    files
  end

  def name 
    obs_datetime.strftime("%Y.%m.%d-%H.%M")
  end
  def path 
    "public/observations/#{name}"
  end
  def self.path
    "public/observations"
  end


end
