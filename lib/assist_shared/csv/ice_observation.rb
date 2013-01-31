module AssistShared
  module CSV
    module IceObservation
      def as_csv opts={}
        [
          self.partial_concentration,
          self.ice_lookup.try(:code),
          self.thickness,
          self.floe_size_lookup.try(:code),
          self.snow_lookup.try(:code),
          self.snow_thickness,
          self.topography.as_csv,
          self.melt_pond.as_csv,
          self.biota_lookup.try(:code),
          self.sediment_lookup.try(:code)
        ]
      end

      def self.headers opts={}
        [
          'PC',
          'T',
          'Z',
          'F',
          'SY',
          'SH',
          Topography.headers,
          MeltPond.headers,
          'A',
          'SD'        
        ].flatten.collect{|i| "#{opts[:prefix]}#{i}#{opts[:suffix]}"}
      end

    end
  end
end