class Cloud < ActiveRecord::Base
  include ImportHandler
  include AssistShared::CSV::Cloud
  include AssistShared::Validations::Cloud
  belongs_to :meteorology
  belongs_to :cloud_lookup

  
 
  def as_json opts={}
    {
      cover: cover,
      height: height,
      cloud_lookup_code: cloud_lookup.try(&:code),
      cloud_type: cloud_type
    }
  end
end
