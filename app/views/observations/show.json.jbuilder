json.(@observation, :obs_datetime, :latitude, :longitude, :hexcode, :uuid)

json.partial! 'observations/user', primary_observer: @observation.primary_observer
json.partial! 'observations/user', collection: @observation.additional_observers, 
  as: :additional_observers

json.partial! 'observations/ice', @observation.ice_attributes
json.partial! 'observations/ice_observations', collection: @observation.ice_observations, 
  as: :ice_observation_attributes
json.partial! 'observations/meteorology', @observation.meteorology_attributes

json.partial! 'observations/ship', @observation.ship
json.partial! 'observations/photos', collection: @observation.photos, as: :photos_attributes
json.partial! 'observations/comments', collection: @observation.comments, 
  as: :comment_attributes