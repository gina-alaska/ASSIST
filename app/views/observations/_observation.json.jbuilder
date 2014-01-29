json.(observation, :obs_datetime, :latitude, :longitude, :hexcode, :uuid)

json.primary_observer do
  json.partial! observation.primary_observer #, partial: 'observations/user', as: :user
end
json.additional_observers do
  json.array! observation.additional_observers 
end
json.ice_attributes do
  json.partial! observation.ice
end
json.ice_observation_attributes observation.ice_observations do |obs|
  json.partial! obs
end

json.meteorology_attributes do
  json.partial! observation.meteorology
end
json.ship_attributes do 
  json.partial! observation.ship
end

json.fauna_attributes observation.faunas do |fauna|
  json.partial! fauna
end

json.photo_attributes do 
  json.partial! observation.photos
end
json.comment_attributes do
  json.partial! observation.comments
end
