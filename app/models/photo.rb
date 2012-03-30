class Photo < ActiveRecord::Base
  include ImportHandler
  validates_uniqueness_of :checksum_id, :message => "That photo has already been attached to this report"

  belongs_to :observation
  belongs_to :on_boat_location_lookup

  before_destroy do
    FileUtils.remove(uri) if File.exists?(uri)
  end

  def uri
    File.join(observation.path, name)
  end


  def directory
    observation.path
  end

  def url
    File.join(observation.path, name).gsub!(/public\//,'')
  end

  def as_json opts={}
    {
      checksum_id: checksum_id,
      name: name,
      on_boat_location_lookup_code: on_boat_location_lookup.try(&:code)
    }
  end

end
