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
    @observation.obs_datetime = parse_date( dateFields params )

    if @observation.save
      respond_with @observation do |format|
        format.html { redirect_to proc {edit_observation_url @observation}}
      end
    else
      render :action => :new
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
    @observation.obs_datetime = parse_date( dateFields params )

    if @observation.update_attributes(params[:observation])
      if request.xhr?
        render :json => @observation, :layout => false, :status => :accepted
      else
        redirect_to @observation
      end
    else
      if request.xhr?
        render :json => {:errors => @observation.errors, :flash => @observation.errors.full_messages}, :layout => false, :status => :unprocessable_entity
      else
        render :action => :edit, :status => :unprocessable_entity
      end
    end
  end

  def preview
    @observation = Observation.where(:id => params[:observation_id]).first

    if request.xhr?
      respond_with @observation, :layout => false
    else
      respond_with @observation
    end
  end

protected
  def parse_date arr
    begin
      DateTime.parse("#{arr[:observation_date]} #{arr[:observation_time]}")
    rescue
      nil
    end
  end

  def dateFields p
    p.slice(:observation_date, :observation_time)
  end
end