class Cloud < ActiveRecord::Base
  include ImportHanlder
  belongs_to :meteorology
end
