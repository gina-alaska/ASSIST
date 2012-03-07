class MeteorologiesController < ApplicationController

  def update
    @meteorology = Meteorology.where(:id => params[:id]).first


    if @meteorology.update_attributes(params[:meteorology])
      if request.xhr?
        render :json => @meteorology, :layout => false, :status => :accepted
      else
        redirect_to @meteorology
      end
    else
      if request.xhr?
        render :json => @meteorology.errors, :layout => false, :status => :unprocessable_entity
      else
        render :action => :edit, :status => :unprocessable_entity
      end
    end
  end
end
