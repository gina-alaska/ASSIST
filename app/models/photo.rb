class Photo < ActiveRecord::Base
  validates_uniqueness_of :name, :message => "That photo has already been uploaded"

  belongs_to :observation
  belongs_to :on_boat_location_lookup

  def uri
    "/assets/#{observation_id}/#{name}"
  end


  def directory
    Rails.root.join('public', 'uploads', "observation_#{observation_id}")
  end

  def url
    File.join('public','uploads', "observation_#{observation_id}", name)
  end

end
