class Comment < ActiveRecord::Base
  include ImportHandler

  belongs_to :user
  belongs_to :observation
end
