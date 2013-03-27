require 'csv'

class Observation < ActiveRecord::Base
  class InvalidLookupException < Exception;end
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

  def as_json opts={}
    data = {
      obs_datetime: obs_datetime,
      primary_observer: primary_observer.as_json,
      additional_observers: additional_observers.collect(&:as_json),
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
      table = key.gsub(/^thi(n|ck)_ice_lookup_code$/,"ice_lookup_code")

      case v.class.to_s
      when "Hash"
        h[key] = lookup_id_to_code(v)
      when "Array"
        h[key] = v.collect{|item| item.is_a?(Hash) ? lookup_id_to_code(item) : item } 
      else
        #If it's a lookup and not nil, convert it into a code
        if(key =~ /lookup_code$/ and !!v)
          #Use where instead of find. If any bad values got injected it will turn them into nil
          table = key.gsub(/^thi(n|ck)_ice_lookup_code$/,"ice_lookup_code")
          v = table.chomp("_code").camelcase.constantize.where(id: v).first.try(&:code)
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

  def to_param
    self.to_s
  end
  
  def to_s
    obs_datetime = Time.new if obs_datetime.nil?
    "#{obs_datetime.strftime("%Y%m%d%H%M")}-#{id}"
  end

  private
  def self.lookup_code_to_id attrs
    attrs.inject(Hash.new) do |h,(k,v)|
      key = k.to_s.gsub(/lookup_code$/, "lookup_id")
  
      if key =~ /lookup_id$/ and not v.nil?
        table = key.gsub(/^thi(n|ck)_ice_lookup_id$/,"ice_lookup_id")
        lookup = table.chomp("_id").camelcase.constantize.where(code: v).first
        raise InvalidLookupException, "Unknown Lookup Id -- #{table}: #{v.inspect}" if lookup.nil?
        v = lookup.id
      end
      
      case v.class.to_s
      when "Hash"
        h[key] = lookup_code_to_id(v)
      when "Array"
        h[key] = v.collect{|el| el.is_a?(Hash) ? lookup_code_to_id(el) : el}
      else
        h[key] = v
      end
  
      h
    end
  end  

end

