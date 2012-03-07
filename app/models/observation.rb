class Observation < ActiveRecord::Base
  has_one  :ice
  has_many  :photos
  has_many :ice_observations do
    def obs_type o
      o = o.to_sym
      ice = where(:obs_type => o).first
      ice ||= IceObservation.create :obs_type => o
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

  after_initialize do
    create_ice if ice.nil?
    create_meteorology if meteorology.nil?
  end


  def finalized?
    #self.finalized_at
    false
  end
end
