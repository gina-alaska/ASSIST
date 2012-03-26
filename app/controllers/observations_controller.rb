class ObservationsController < ApplicationController
  respond_to :html, :csv

  def index
   # @observations = Observation.find(params[:ids])
    @observations ||= Observation.all


    respond_with @observations do |format|
      format.html
      format.csv 
    end
  end

  def new
    @observation = Observation.new
    respond_with(@observation)
  end

  def create
    obs = params[:observation]
    @observation = Observation.new obs
    @observation.obs_datetime = parse_date( dateFields params )
  
    if @observation.save
      respond_with @observation do |format|
        format.html { redirect_to edit_observation_url(@observation) + "#ice" }
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
    obs = params[:observation]
    @observation = Observation.where(:id => params[:id]).first
    @observation.obs_datetime = parse_date( dateFields params )
 
    if @observation.update_attributes(obs)
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

  def show
    @observation = Observation.where(:id => params[:id]).first

    if request.xhr?
      respond_with @observation, :layout => false
    else
      respond_with @observation
    end
  end

  def manage

  end

  def import
    data = params[:data]
    year = params[:year]


    mapFile = Rails.root.join("config/import_map_#{year}.yml") 
    mapFile = File.exists?(mapFile) ? mapFile : Rails.root.join("config/import_map.yml")

    logger.info(mapFile)

    results = Observation.from_csv( Rails.root.join( data.tempfile.path ).to_s, mapFile.to_s )


    if request.xhr? 
      render :json => {:success => true, :imported => results[:count], :errors => results[:errors] }
    else
      redirect_to observation_url
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