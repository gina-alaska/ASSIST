class CloudLookup < ActiveRecord::Base
  def as_json(options=nil)
    serializable_hash({:only => [:id,:name, :code] })
  end

  def code_with_name
    "#{code.upcase.rjust(3,' ')} :: #{name}"
  end
end
