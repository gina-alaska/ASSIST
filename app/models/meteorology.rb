class Meteorology < ActiveRecord::Base
  belongs_to :observation
  belongs_to :weather_lookup
  belongs_to :visibility_lookup
  belongs_to :cloud_lookup
end
