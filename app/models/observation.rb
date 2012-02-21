class Observation < ActiveRecord::Base
  has_many :ices
  accepts_nested_attributes_for :ices
  
end
