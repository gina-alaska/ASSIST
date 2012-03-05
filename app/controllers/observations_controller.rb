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
    @observation.ice_observations << IceObservation.new(:obs_type => "primary")
    @observation.ice_observations << IceObservation.new(:obs_type => "secondary")
    @observation.ice_observations << IceObservation.new(:obs_type => "tertiary")

    if @observation.save!
      respond_with @observation do |format|
        format.html { redirect_to proc {edit_observation_url @observation}}
      end
    end
  end

  def edit
    @observation = Observation.includes(:ice,:meteorology,:additional_observers).where(:id => params[:id]).first
    @observation.build_ice if @observation.ice.nil?
    @observation.build_meteorology if @observation.meteorology.nil?
    @observation.build_primary_observer if @observation.primary_observer.nil?

    @observation.additional_observers.build if @observation.additional_observers.empty?
=begin
    if @observation.ice_observations.empty?
     @observation.ice_observations.build
      @observation.ice_observations.each do |ice|
        ice.build_melt_pond
        ice.build_topography
      end

    end
=end
    respond_with @observation
  end

  def update
    @observation = Observation.where(:id => params[:id]).first


    if @observation.update_attributes(params[:observation])
      if request.xhr?
        render :json => @observation, :layout => false, :status => :accepted
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