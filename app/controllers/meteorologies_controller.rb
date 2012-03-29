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
        render :json => {:errors => @meteorology.errors, :flash => @meteorology.errors.full_messages}, :layout => false, :status => :unprocessable_entity
      else
        render :action => :edit, :status => :unprocessable_entity
      end
    end
  end

  def create
    @meteorology = Meteorology.new(params[:meteorology])


    if @meteorology.save(params[:meteorology])
      if request.xhr?
        render :json => @meteorology, :layout => false, :status => :accepted
      else
        redirect_to @meteorology
      end
    else
      if request.xhr?
        render :json => {:errors => @meteorology.errors, :flash => @meteorology.errors.full_messages}, :layout => false, :status => :unprocessable_entity
      else
        render :action => :edit, :status => :unprocessable_entity
      end
    end
  end
end
