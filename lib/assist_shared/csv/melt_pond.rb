module AssistShared
  module CSV
    module MeltPond
      def as_csv opts={}
        [
          self.surface_coverage,
          self.max_depth_lookup.try(:code),
          self.pattern_lookup.try(:code),
          self.surface_lookup.try(:code),
          self.freeboard
        ]
      end

      def self.headers opts={}
        [ 'MPC', 'MPD', 'MPP', 'MPT', 'MPF']
      end

    end
  end
end