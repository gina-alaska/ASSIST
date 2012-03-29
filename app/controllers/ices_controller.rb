class IcesController < ApplicationController
  
  def update
    @ice = Ice.where(:id => params[:id]).first


    if @ice.update_attributes(params[:ice])
      if request.xhr?
        render :json => @ice, :layout => false, :status => :accepted
      else
        redirect_to @ice
      end
    else
      if request.xhr?
        render :json => {:errors => @ice.errors, :flash => @ice.errors.full_messages}, :layout => false, :status => :unprocessable_entity
      else
        render :action => :edit, :status => :unprocessable_entity
      end
    end
  end

  def create
    @ice = Ice.new(params[:ice])

    if @ice.save
      if request.xhr?
        render :json => @ice, :layout => false, :status => :accepted
      else
        redirect_to @ice
      end
    else
      if request.xhr?
        render :json => {:errors => @ice.errors, :flash => @ice.errors.full_messages}, :layout => false, :status => :unprocessable_entity
      else
        render :action => :edit, :status => :unprocessable_entity
      end
    end

  end
end
