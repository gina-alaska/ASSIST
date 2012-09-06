class Ice < ActiveRecord::Base
  include ImportHandler
  include AssistShared::CSV::Ice
  include AssistShared::Validations::Ice

  belongs_to :observation
  belongs_to :thin_ice_lookup, :class_name => IceLookup
  belongs_to :thick_ice_lookup, :class_name => IceLookup
  belongs_to :open_water_lookup

  # validates_presence_of :total_concentration, 
  #                       :allow_nil => false, 
  #                       :message => "Total Concentration is required",
  #                       :if => :finalized_or_ice?
  
  def finalized_or_ice?
    return false if observation.nil?
    o = Observation.find(self.observation_id)
    o.finalized? || o.status == 'ice'
  end

  # def as_csv
  #   [
  #     total_concentration,
  #     open_water_lookup.try(&:code),
  #     thin_ice_lookup.try(&:code),
  #     thick_ice_lookup.try(&:code)
  #   ]
  # end

  def as_json opts={} 
    {
      total_concentration: total_concentration,
      open_water_lookup_code: open_water_lookup.try(&:code),
      thin_ice_lookup_code: thin_ice_lookup.try(&:code),
      thick_ice_lookup_code: thick_ice_lookup.try(&:code)
    }
  end

  # def self.headers opts={}
  #   headers = %w( TC OW OT TH )
  #   headers.map!{|h| "#{opts[:prefix]}#{h}"} if opts[:prefix]
  #   headers.map!{|h| "#{h}#{opts[:postfix]}"}  if opts[:postfix] 
  #   headers
  # end
end
