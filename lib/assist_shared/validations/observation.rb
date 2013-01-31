module AssistShared
  module Validations
    module Observation
      extend ActiveSupport::Concern
      include ActiveModel::Validations
      
      included do
        attr_accessor :finalize

        validates_presence_of :primary_observer, :obs_datetime, :latitude, :longitude, :hexcode
        validates_uniqueness_of :hexcode, message: "This cruise already exists (Lat/Lon, Time)"
        
        validate :location
        
        def location 
          errors.add(:latitude, "Latitudes must be between -90 and 90") unless (latitude.to_f <= 90 && latitude.to_f >= -90)
          errors.add(:longitude, "Longitude must be between -180 and 180") unless (longitude.to_f <= 180 && longitude.to_f >= -180)
        end
      end
      
      def finalize?
        self.finalize.nil? ? true : self.finalize
      end
    
      def save opts={}
        opts.merge!(validate: self.finalize?)
        super opts
      end
    
    end
  end
end
