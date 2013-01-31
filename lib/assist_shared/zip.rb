module AssistShared
  module Zip
    extend ActiveSupport::Concern
    
    module InstanceMethods
      def to_zip opts={}
        Zip::ZipFile.open(opts[:file], Zip::ZipFile::CREATE) do |zip|
          [opts[:formats]].flatten.each do |format|
            puts format
          end  
        end
      end
    end
  end
end