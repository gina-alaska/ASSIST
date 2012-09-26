class Observations::BuildController < ApplicationController
  include Wicked::Wizard
  
  steps :general, :ice, :meteorology, :photos, :comments, :finalize
  
  def show
    @observation = Observation.find(params[:observation_id])
    @observation.valid?
    render_wizard
  end
  
  def edit
    @observation = Observation.where(:id => params[:observation_id])
    @observation = @observation.includes([:ice, :ice_observations => [:topography, :melt_pond]],:meteorology => [:clouds])
    
    respond_to do |format|
      format.html
    end
  end
  
  def update
    @observation = Observation.where(:id => params[:observation_id])
    
    case params[:step] 
    when :ice
      @observation = @observation.includes([:ice, :ice_observations => [:topography, :melt_pond]])
    when :meteorology
      @observation = @observation.includes(:meteorology => [:clouds])
    when :photos
      @observation = @observation.includes(:photos)
    when :comments
      @observation = @observation.includes(:comments)
    end
    
    # if params[:id] == "finalize"
    #   @observation = @observation.includes(
    # end
    
    @observation = @observation.first
    
    obs_datetime = parse_date
    @observation.obs_datetime = obs_datetime unless obs_datetime.nil?
    
    @observation.finalize = (params[:id] == "validate")  

    @observation.status = params[:step]
    
    
    if @observation.update_attributes(observation_params)
      if request.xhr?
        render partial: 'shared/errors', model: @observation, layout: false
      else
        render params[:id]
      end
    else
      if request.xhr?
        render partial: 'shared/errors', model: @observation, layout: false
        # render json: {errors: @observation.errors, flash: @observation.errors.full_messages}, :layout => false, :status => :unprocessable_entity
      else
        render determine_error_step
      end
    end   
  end
  
  def create
    obs = params[:observation]
    @observation = Observation.new obs
    @observation.obs_datetime = parse_date
    
    if @observation.save
      respond_with @observation do |format|
        format.html { redirect_to observation_build_path }
      end
    else
      render :new
    end
  end
  
  
  protected
    def parse_date
      dt = params.slice(:observation_date, :observation_hour, :observation_minute)
      begin
        DateTime.parse("#{dt[:observation_date]} #{dt[:observation_hour]}:#{dt[:observation_minute]} UTC")
      rescue
        nil
      end
    end
    
    def observation_params
      p = params[:observation] || {}

      unless p.nil?
        p[:ice_attributes][:total_concentration] = nil if p[:ice_attributes] && p[:ice_attributes][:total_concentration].empty?
      end
      p[:status] = step
      p
    end
    
    def determine_error_step
      step = @observation.errors.keys.first.to_s.split(".").first
      case step
      when "ice", "ice_observations", "topography", "melt_pond"
        :ice
      when "meteorology", "clouds"
        :meteorology
      else
        :general
      end
    end
    
end