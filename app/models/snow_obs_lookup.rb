class SnowObsLookup < ActiveRecord::Base

  def as_json(options=nil)
    serializable_hash({:only => [:id,:name] })
  end

end
