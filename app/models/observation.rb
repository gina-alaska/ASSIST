require 'csv'


class Observation < ActiveRecord::Base
  include ImportHandler

  has_one  :ice
  has_many :photos
  has_many :comments
  has_many :ice_observations do
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
  has_one  :meteorology
  has_many :observation_users
  belongs_to :primary_observer, :class_name => "User"
  has_many :additional_observers, :through => :observation_users, :class_name => "User", :source => :user

  accepts_nested_attributes_for :ice
  accepts_nested_attributes_for :ice_observations
  accepts_nested_attributes_for :meteorology
  accepts_nested_attributes_for :photos

  validates_presence_of :primary_observer_id
  validates_presence_of :obs_datetime, :message => "Invalid or no date given"
  #Allow DD or DM(S)
  validates_format_of :latitude, :with => /^(\+|-)?[0-9]{1,2}(\s[0-9]{1,2}(\.[0-9]{1,2})?|\.[0-9]*)(\s?[NS])?$/
  validates_format_of :longitude, :with => /^(\+|-)?[0-9]{1,3}(\s[0-9]{1,2}(\.[0-9]{1,2})?|\.[0-9]*)(\s?[EW])?$/

  after_initialize do
    create_ice if ice.nil?
    create_meteorology if meteorology.nil?
  end

  before_save do
    latitude = to_dd(latitude) if latitude =~ /^(\+|-)?[0-9]{1,2}\s[0-9]{1,2}(\.[0-9]{1,2})?(\s?[NS])?$/
    longitude = to_dd(longitude) if longitude =~ /^(\+|-)?[0-9]{1,3}\s[0-9]{1,2}(\.[0-9]{1,2})?(\s?[EW])?$/
  end

  def finalized?
    #self.finalized_at
    false
  end

  def self.from_csv csv, map = "import_map.yml"

    if map.is_a? String
      map = ::YAML.load_file map
    end

    if csv.is_a? String
      csv = ::CSV.open csv, {:headers => true, :return_headers => false}
    end

    unknownObserver = User.find_or_create_by_firstname_and_lastname(map[:user][:first_name], map[:user][:last_name])
    csv.each do |row|
      data = parse_csv(row,map)
      date = DateTime.parse "#{data[:year]} #{data[:time]}"

      if data[:observation][:primary_observer_id].nil?
        data[:observation][:primary_observer_id] = unknownObserver.id
      else
        name = data[:observation][:primary_observer_id].split " "
        user = User.find_or_create_by_firstname_and_lastname(name.first, name.last)
        data[:observation][:primary_observer_id] = user.id
      end

      observation = Observation.import(data[:observation])
      observation.obs_datetime = date
      observation.save!
    end

  end

  def self.parse_csv row, map
    data = Hash.new
    map.each do |k,v|
      if v.is_a? String
        data[k] = row.include?(v) ? row[v] : v
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
end
