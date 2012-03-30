class Comment < ActiveRecord::Base
  include ImportHandler

  belongs_to :user
  belongs_to :observation


  def as_json opts={}
    {
      user_attributes: user.try(&:as_json),
      data: data
    }
  end
end
