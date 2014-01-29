class Fauna < ActiveRecord::Base
  include ImportHandler
  
  attr_accessible :name, :count

  belongs_to :observation
end
