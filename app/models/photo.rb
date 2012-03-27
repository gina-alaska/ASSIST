class Photo < ActiveRecord::Base
  validates_uniqueness_of :checksum_id, :message => "That photo has already been attached to this report"

  belongs_to :observation
  belongs_to :on_boat_location_lookup

  before_destroy do
    File.remove( File.join(directory, name))    
  end

  def uri
    File.join(observation.path, name)
  end


  def directory
    Rails.root.join(observation.path)
  end

  def url
    File.join(observation.path, name).gsub!(/public\//,'')
  end

end
