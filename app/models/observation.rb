class Observation < ActiveRecord::Base
  has_one  :ice
  has_many  :photos
  has_many :ice_observations
  has_one  :meteorology
  has_many :observation_users
  belongs_to :primary_observer, :class_name => "User"
  has_many :additional_observers, :through => :observation_users, :class_name => "User", :source => :user
  accepts_nested_attributes_for :ice
  accepts_nested_attributes_for :ice_observations
  accepts_nested_attributes_for :meteorology
  accepts_nested_attributes_for :photos

  def finalized?
    #self.finalized_at
    false
  end
end
