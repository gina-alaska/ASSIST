module AssistShared
  module CSV
    module Observation
      extend ActiveSupport::Concern
      def as_csv opts={}
        [ 
          self.obs_datetime,
          first_and_last_name(self.primary_observer),
          self.additional_observers.collect{|o| first_and_last_name(o)}.join(":"),
          self.latitude,
          self.longitude,
          self.ice.as_csv,
          self.meteorology.as_csv,
          self.ice_observations.primary.as_csv, 
          self.ice_observations.secondary.as_csv, 
          self.ice_observations.tertiary.as_csv
        ].flatten
      end
      
      def to_csv opts={}
        c = ::CSV.generate(headers: true) do |csv|
          csv << self.class.headers
          csv << self.as_csv
        end
        c
      end
      
      def first_and_last_name( observer )
        if observer.is_a? Hash
          o = "#{observer['firstname']} #{observer['lastname']}"
        elsif observer.is_a? String
          o = observer
        else
          o = "#{observer.firstname} #{observer.lastname}"
        end
        o
      end
      
      module ClassMethods
        def headers opts = {}
          [
            'Date',
            'PO',
            'AO',
            'LAT',
            'LON',
            Ice.headers,
            Meteorology.headers,
            %w{ P S T }.collect{|type| IceObservation.headers prefix: type }
          ].flatten
        end
      end
      included do
        extend ClassMethods
      end
    end
  end
end
      