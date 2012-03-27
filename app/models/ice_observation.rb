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


  def as_csv
    [ 
      obs_type,
      partial_concentration,
      ice_lookup.try(&:code),
      thickness,
      floe_size_lookup.try(&:code),
      snow_lookup.try(&:code),
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
      ice_lookup: ice_lookup.try(&:code),
      thickness: thickness,
      floe_size_lookup: floe_size_lookup.try(&:code), 
      snow_lookup: snow_lookup.try(&:code),
      biota_lookup: biota_lookup.try(&:code),
      sediment_lookup: sediment_lookup.try(&:code),
      melt_pond: melt_pond.as_json,
      topography: topography.as_json
    }
  end


  def self.headers opts={}
    puts opts
    headers = %w( ObsType C T Z F SY AL SD )
    headers.map!{|h| "#{opts[:prefix]}#{h}"} unless opts[:prefix].nil?
    headers.map!{|h| "#{h}#{opts[:postfix]}"}  unless opts[:postfix].nil? 
    headers.push(MeltPond.headers)
    headers.push(Topography.headers)
  end
end
