#This should evenutally load a yaml file containing cruise info
module Assist
  class Cruise
    class << self
      attr_accessor :id
      attr_accessor :ship
      attr_accessor :start_date
      attr_accessor :end_date
    end
  end
end
