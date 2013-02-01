class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def observation_id
    params[:id].split("-").last
  end
  
end


