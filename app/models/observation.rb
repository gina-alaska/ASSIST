require 'csv'

class Observation < ActiveRecord::Base
  class InvalidLookupException < Exception;end
  include ImportHandler

  include AssistShared::CSV::Observation
  include AssistShared::Validations::Observation

  has_one  :ship, :dependent => :destroy
  has_one  :ice, :dependent => :destroy
  has_many :photos, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :ice_observations, :dependent => :destroy do
    def obs_type o
      select { |item| item.obs_type == o }.first
    end
    def primary
      obs_type "primary"
    end
    def secondary
      obs_type "secondary"
    end
    def tertiary
      obs_type "tertiary"
    end
  end
  has_one  :meteorology, :dependent => :destroy
  has_many :observation_users
  belongs_to :primary_observer, :class_name => "User"
  has_many :additional_observers, :through => :observation_users, :class_name => "User", :source => :user
  has_many :faunas, :dependent => :destroy
  has_many :notes, :dependent => :destroy

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
    obs.ship = Ship.new if obs.ship.nil?
  end

  accepts_nested_attributes_for :ice,:ice_observations,:meteorology,:photos,:ship
  accepts_nested_attributes_for :faunas, reject_if: proc { |fauna| fauna['name'].blank? }, allow_destroy: true

  before_save do
    self.latitude = self.to_dd(latitude) if latitude =~ /^(\+|-)?[0-9]{1,2}\s[0-9]{1,2}(\s[0-9]{1,2})?(\s?[NS])?$/
    self.longitude = self.to_dd(longitude) if longitude =~ /^(\+|-)?[0-9]{1,3}\s[0-9]{1,2}(\s[0-9]{1,2})?(\s?[EW])?$/
    self.hexcode = Digest::MD5.hexdigest("#{obs_datetime}#{latitude}#{longitude}#{primary_observer.try(&:first_and_last_name)}")
  end

  def to_dd dms
    deg,min,sec = dms.split " "
    dec = (min.to_i * 60 + sec.to_i) / 3600.0
    dd = deg.to_i > 0 ? "#{(deg.to_i+dec)}" : "#{deg.to_i - dec}"
    dd.to_f.round(4)
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

  def to_param
    self.to_s
  end

  def name
    obs_datetime.try(:strftime, "%Y.%m.%d-%H.%M") || "INVALID_OBSERVATION_#{self.id}"
  end

  def to_s
    self.obs_datetime = Time.new if self.obs_datetime.nil?
    "#{self.obs_datetime.strftime("%Y%m%d%H%M")}-#{self.id}"
  end

  def export_path
    File.join(EXPORT_DIR, self.to_s)
  end

  def export_name(format)
    File.join(export_path, "#{name}.#{format}")
  end

  def export
    FileUtils.mkdir_p(export_path) unless File.exists?(export_path)

    ['csv','json'].each do |format|
      file = File.join(export_path, "#{name}.#{format}")
      File.open(file, "w") do |f|
        f << self.send("to_#{format}")
      end
    end

    return true
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
