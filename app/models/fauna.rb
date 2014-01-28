class Fauna < ActiveRecord::Base
  include ImportHandler
  
  attr_accessible :type, :count

  belongs_to :observation
end
