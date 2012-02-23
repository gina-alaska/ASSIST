class User < ActiveRecord::Base
  has_many :observation_users
  has_many :observations, :through => :observation_user
end
