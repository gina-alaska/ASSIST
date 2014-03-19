class BiotaLocationLookup < ActiveRecord::Base
  attr_accessible :code, :name

  has_many :ice_observations

  def code_with_name
    "#{code.to_s.rjust(2,'0')} :: #{name}"
  end
end
