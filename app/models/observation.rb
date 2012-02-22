class Observation < ActiveRecord::Base
  has_many :ices
  has_many :ice_observations
  has_many :meteorologies
  has_many :observation_users
  has_many :users, :through => :observation_users
  accepts_nested_attributes_for :ices, :ice_observations, :meteorologies
  
end
