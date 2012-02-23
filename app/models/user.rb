class User < ActiveRecord::Base
  has_many :observation_users
  has_many :observations, :through => :observation_user

  def first_and_last_name
    [firstname, lastname].join " "
  end
end
