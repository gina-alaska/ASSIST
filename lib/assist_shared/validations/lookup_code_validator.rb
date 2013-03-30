module AssistShared
  module Validations
    class LookupCodeValidator < ActiveModel::Validator
      def validate(record)
        if options[:fields].any?
          options[:fields].each do |field, table|
            klass = table.camelcase.constantize
            unless options[:allow_blank] && record.send(field).nil?
              unless klass.where(id: record.send(field)).any?
                if record.send(field).nil?
                  record.errors.add field, "cannot be blank"
                else
                  record.errors.add field, "contains an invalid lookup code"
                end
              end
            end
          end
        end
      end
    end
  end
end