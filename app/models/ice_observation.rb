class IceObservation < ActiveRecord::Base
  include ImportHandler

  belongs_to :observation
  has_one :melt_pond, :dependent => :destroy
  has_one :topography, :dependent => :destroy
  belongs_to :ice_lookup
  belongs_to :floe_size_lookup
  belongs_to :sediment_lookup
  belongs_to :biota_lookup
  belongs_to :snow_lookup

  accepts_nested_attributes_for :melt_pond
  accepts_nested_attributes_for :topography

  after_create do |obs|
    obs.topography = Topography.create if obs.topography.nil?
    obs.melt_pond = MeltPond.create if obs.melt_pond.nil?
  end

  def as_csv
    [ 
      obs_type,
      partial_concentration,
      ice_lookup.try(&:code),
      thickness,
      floe_size_lookup.try(&:code),
      snow_lookup.try(&:code),
      snow_thickness,
      biota_lookup.try(&:code),
      sediment_lookup.try(&:code),
      melt_pond.as_csv,
      topography.as_csv
    ]
  end

  def as_json opts={}
    {
      obs_type: obs_type,
      partial_concentration: partial_concentration,
      ice_lookup_code: ice_lookup.try(&:code),
      thickness: thickness,
      floe_size_lookup_code: floe_size_lookup.try(&:code), 
      snow_lookup_code: snow_lookup.try(&:code),
      snow_thicness: snow_thickness,
      biota_lookup_code: biota_lookup.try(&:code),
      sediment_lookup_code: sediment_lookup.try(&:code),
      melt_pond_attributes: melt_pond.as_json,
      topography_attributes: topography.as_json
    }
  end


  def self.headers opts={}
    puts opts
    headers = %w( ObsType C T Z F SY SH AL SD )
    headers.map!{|h| "#{opts[:prefix]}#{h}"} unless opts[:prefix].nil?
    headers.map!{|h| "#{h}#{opts[:postfix]}"}  unless opts[:postfix].nil? 
    headers.push(MeltPond.headers prefix: opts[:prefix])
    headers.push(Topography.headers prefix: opts[:prefix])
  end
end
