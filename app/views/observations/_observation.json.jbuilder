json.(observation, :obs_datetime, :latitude, :longitude, :hexcode, :uuid)

json.primary_observer do
  json.partial! observation.primary_observer
end

json.additional_observers do
  json.array! observation.additional_observers
end

json.ice_attributes do
  json.partial! observation.ice
end

json.ice_observations_attributes observation.ice_observations do |obs|
  json.partial! obs
end

json.meteorology_attributes do
  json.partial! observation.meteorology
end

json.ship_attributes do
  json.partial! observation.ship
end

json.faunas_attributes observation.faunas do |fauna|
  json.partial! fauna
end

json.photos_attributes observation.photos do |photo|
  json.partial! photo
end

json.comments_attributes observation.comments do |comment|
  json.partial! comment
end

json.notes_attributes observation.notes do |note|
  json.partial! note
end
