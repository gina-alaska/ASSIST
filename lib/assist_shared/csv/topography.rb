module AssistShared
  module CSV
    module Topography
      def as_csv opts={}
        [
          self.topography_lookup.try(:code),
          self.concentration,
          self.ridge_height,
          self.old,
          self.consolidated,
          self.snow_covered
        ]
      end

      def self.headers opts={}
        [
          'Top',
          'C',
          'RH',
          'Old',
          'Cs',
          'SC'
        ]
      end

    end
  end
end