class SurfaceLookup < ActiveRecord::Base

  def as_json(options=nil)
    serializable_hash({:only => [:id,:name, :code] })
  end

  def code_with_name
    "(#{code.to_s.rjust(3,'0')}) :: #{name}"
  end


end
