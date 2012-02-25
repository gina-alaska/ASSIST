class ObservationsController < ApplicationController
  respond_to :html

  def index
    @observations = Observation.all
    respond_with @observations
  end

  def new
    @observation = Observation.new
    respond_with(@observation)
  end

  def create
    @observation = Observation.new params[:observation]

    if @observation.save!
      respond_with @observation do |format|
        format.html { render :action => :edit}
      end
    end
  end

  def edit
    @observation = Observation.includes(:ice,:meteorology,:additional_observers).where(:id => params[:id]).first
    @observation.build_ice if @observation.ice.nil?
    @observation.build_meteorology if @observation.meteorology.nil?
    @observation.build_primary_observer if @observation.primary_observer.nil?
    @observation.additional_observers.build if @observation.additional_observers.empty?
    respond_with @observation
  end

  def update
    @observation = Observation.where(:id => params[:id]).first

    logger.info("********************")
    logger.info(params[:observation]);
    logger.info("********************")

    if @observation.update_attributes(params[:observation])
      if request.xhr?
        render :json => @observation, :layout => false, :status => :updated
      else
        redirect_to @observation
      end
    else
      if request.xhr?
        render :json => @observation.errors, :layout => false, :status => :unprocessable_entity
      else
        render :action => :edit, :status => :unprocessable_entity
      end
    end
  end
end