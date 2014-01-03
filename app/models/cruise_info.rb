class CruiseInfo < ActiveRecord::Base
  attr_accessible :ship, :purpose, :chief_scientist, :captain, :begin_at, :end_at
  
  validates_presence_of :ship, :begin_at, :purpose
  
  def to_s
    "#{ship} - #{[begin_at, end_at].join(' - ')}"
  end
end
