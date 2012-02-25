UserChild = Struct.new(:id, :name)

class WeatherLookup < ActiveRecord::Base

  def as_json(options=nil)
    serializable_hash({:only => [:id, :name, :code, :comment] })
  end

  def code_with_name
    "(#{code.to_s.rjust(3,'0')}) :: #{name}"
  end

  def children
    [UserChild.new(0, 'A')]
  end
end
