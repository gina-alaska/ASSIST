module AssistShared
  module CSV
    module Ice
      def as_csv opts={}
        [
          self.total_concentration,
          self.open_water_lookup.try(:code),
          self.thin_ice_lookup.try(:code),
          self.thick_ice_lookup.try(:code),
        ]
      end

      def self.headers opts={}
        [ 'TC', 'OW', 'OT', 'TH' ]
      end

    end
  end
end