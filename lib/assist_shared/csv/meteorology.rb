module AssistShared
  module CSV
    module Meteorology
      def as_csv opts={}
        [
          self.visibility_lookup.try(:code),
          self.weather_lookup.try(:code),
          self.clouds.high.as_csv,
          self.clouds.medium.as_csv,
          self.clouds.low.as_csv
        ]
      end
      
      def self.headers opts={}
        [
          'V',
          'WX',
          %W{ H M L }.collect{|type| Cloud.headers prefix: type}        
        ].flatten
      end
      
    end
  end
end