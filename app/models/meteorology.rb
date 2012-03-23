class Meteorology < ActiveRecord::Base
  include ImportHandler

  belongs_to :observation
  belongs_to :weather_lookup
  belongs_to :visibility_lookup
  has_many :clouds do
    def cloud_type c
      c = c.to_sym
      cld = where(:cloud_type => c).first
      cld ||= create :cloud_type => c
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

  accepts_nested_attributes_for :clouds
end
