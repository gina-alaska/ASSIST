class Observation < ActiveRecord::Base
  has_one  :ice
  has_many :ice_observations
  has_one  :meteorology
  has_many :observation_users
  has_one :primary_observer, :class_name => "User"
  has_many :additional_observers, :through => :observation_users, :class_name => "User"
  accepts_nested_attributes_for :ice, :ice_observations, :meteorology
  
end
