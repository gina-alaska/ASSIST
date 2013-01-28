class CruiseInfosController < ApplicationController
  def new
    @cruise = CruiseInfo.new
  end
  
  def create
    @cruise = CruiseInfo.new cruise_params
    
    if @cruise.save
      redirect_to root_url
    else
      render :new
    end
  end
  
  private
  def cruise_params
    params[:cruise_info]
  end
end