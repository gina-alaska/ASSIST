class User < ActiveRecord::Base
  has_many :observation_users
  has_many :observations, :through => :observation_user


  validates_presence_of :firstname, :lastname

  def first_and_last_name
    [firstname, lastname].join " "
  end

  def as_json opts={}
    { 
      firstname: firstname,
      lastname: lastname
    }
  end
end
