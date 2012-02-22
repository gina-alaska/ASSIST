class RegionLookup < ActiveRecord::Base

  def as_json(options=nil)
    serializable_hash({:only => [:id,:region, :subregion, :code] })
  end

end
