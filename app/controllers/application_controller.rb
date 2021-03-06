class ApplicationController < ActionController::Base
  protect_from_forgery

  def default_url_options 
    if Rails.env.production?
      {port: 8080}
    else
      {}
    end
  end

  private
  def observation_id
    params[:id].split("-").last
  end
  
end


