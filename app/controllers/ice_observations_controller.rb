class IceObservationsController < ApplicationController
  def update
    @ice_observation = IceObservation.where(:id => params[:id]).first


    if @ice_observation.update_attributes(params[:ice_observation])
      if request.xhr?
        render :json => @ice_observation, :layout => false, :status => :accepted
      else
        redirect_to @ice_observation
      end
    else
      if request.xhr?
        render :json => {:errors => @ice_observation.errors, :flash => @ice_observation.errors.full_messages}, :layout => false, :status => :unprocessable_entity
      else
        render :action => :edit, :status => :unprocessable_entity
      end
    end
  end
end
