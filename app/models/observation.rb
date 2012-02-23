class Observation < ActiveRecord::Base
  has_one  :ice
  has_many :ice_observations
  has_one  :meteorology
  has_many :observation_users
  has_many :users, :through => :observation_users
  accepts_nested_attributes_for :ice, :ice_observations, :meteorology
  
end
