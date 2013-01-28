class CruiseInfo < ActiveRecord::Base
  attr_accessible :season, :ship
  
  validates_presence_of :ship, :season
  
  def to_s
    "#{ship} - #{season}"
  end
end
