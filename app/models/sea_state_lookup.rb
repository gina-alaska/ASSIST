class SeaStateLookup < ActiveRecord::Base
  def as_json(options=nil)
    serializable_hash({:only => [:id,:name, :code] })
  end

end
