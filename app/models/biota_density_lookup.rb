class BiotaDensityLookup < ActiveRecord::Base
  attr_accessible :code, :name

  def code_with_name
    "#{code} :: #{name}"
  end
end
