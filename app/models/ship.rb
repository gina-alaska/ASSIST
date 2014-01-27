class Ship < ActiveRecord::Base
  include ImportHandler
  include AssistShared::CSV::Ship
  include AssistShared::Validations::Ship

  attr_accessible :heading, :observation_id, :power, :ship_activity_lookup_id, :speed
  
  belongs_to :observation
  belongs_to :ship_activity_lookup
  
  def as_json opts={}
    super except: [:id, :created_at, :updated_at]
  end
end
