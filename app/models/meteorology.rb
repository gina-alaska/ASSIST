class Meteorology < ActiveRecord::Base
  include ImportHandler
  include AssistShared::CSV::Meteorology
  include AssistShared::Validations::Meteorology
  
  belongs_to :observation
  belongs_to :weather_lookup
  belongs_to :visibility_lookup
  has_many :clouds, :dependent => :destroy do
    def cloud_type c
      c = c.to_sym
      cld = where(:cloud_type => c).first
      cld
    end
    def high
      cloud_type "high"
    end
    def med
      cloud_type "medium"
    end
    def medium
      cloud_type "medium"
    end
    def low
      cloud_type "low"
    end
  end

  before_create do |met|
    %w(high medium low).each do |cloud_type|
      if(met.clouds.cloud_type(cloud_type).nil?)
        met.clouds << Cloud.new(cloud_type: cloud_type)
      end
    end
  end

  accepts_nested_attributes_for :clouds

  def as_json opts={}
    data = super except: [:id, :created_at, :updated_at, :observation_id]
    data[:cloud_attributes] = self.clouds.as_json
    data
  end

end
