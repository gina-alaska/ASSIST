class Ice < ActiveRecord::Base
  include ImportHandler
  include AssistShared::CSV::Ice
  include AssistShared::Validations::Ice

  belongs_to :observation
  belongs_to :thin_ice_lookup, :class_name => IceLookup
  belongs_to :thick_ice_lookup, :class_name => IceLookup
  belongs_to :open_water_lookup

  def as_json opts={}
    super except: [:id, :created_at, :updated_at, :observation_id]
  end
end
