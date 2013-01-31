module AssistShared
  module CSV
    module Cloud
      def as_csv opts={}
        [
          cloud_lookup.try(:code),
          cover,
          height
        ]
      end

      def self.headers opts={}
        ['Y', 'V', 'H'].collect{|i| "#{opts[:prefix]}#{i}#{opts[:suffix]}"}
      end

    end
  end
end