class CruiseInfosController < ApplicationController
  def new
    @cruise = CruiseInfo.new
    @cruise.valid?
  end
  
  def create
    @cruise = CruiseInfo.new cruise_params
    
    if @cruise.save
      redirect_to root_url
    else
      render :new
    end
  end
  
  def edit
    @cruise = CruiseInfo.first
  end
  
  def update
    @cruise = CruiseInfo.first
    
    if @cruise.update_attributes(cruise_params)
      redirect_to root_url
    else
      render :edit
    end
  end
  
  private
  def cruise_params
    params[:cruise_info]
  end
end
