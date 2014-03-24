class Note < ActiveRecord::Base
  attr_accessible :observation_id, :text

  belongs_to :observation
  validates :text, length: {maximum: 80}
  
end
