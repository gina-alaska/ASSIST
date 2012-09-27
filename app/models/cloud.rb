class Cloud < ActiveRecord::Base
  include ImportHandler
  include AssistShared::CSV::Cloud
  include AssistShared::Validations::Cloud
 
  belongs_to :meteorology
  belongs_to :cloud_lookup

  def as_json opts={}
    super except: [:id, :created_at, :updated_at, :meteorology_id]
  end
  
end
