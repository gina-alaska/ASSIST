class ShipActivityLookup < ActiveRecord::Base
  attr_accessible :code, :name

  def code_with_name
    "#{code.to_s.rjust(2,'0')} :: #{name}"
  end
end
