class OpenWaterLookup < ActiveRecord::Base

  def as_json(options=nil)
    serializable_hash({:only => [:id,:name, :code] })
  end

  def code_with_name
    "#{code.to_s.rjust(1,'0')} :: #{name}"
  end

end
