class Observations::BuildController < ApplicationController
  include Wicked::Wizard
  
  steps :general, :ice, :meteorology, :photos, :comments
  
  def show
    @observation = Observation.find(params[:observation_id])
    
    render_wizard
  end
  
  def update
    @observation = Observation.where(:id => params[:observation_id])
    logger.info("***********************")
    logger.info(params[:id].to_sym)
    case params[:id].to_sym
    when :ice
      @observation = @observation.includes([:ice, :ice_observations])
    when :meteorology
      @observation = @observation.includes(:meteorology)
    when :photos
      @observation = @observation.includes(:photos)
    when :comments
      @observation = @observation.includes(:comments)
    end
    
    @observation = @observation.first
    obs_datetime = parse_date
    @observation.obs_datetime = obs_datetime unless obs_datetime.nil?
    
    @observation.status = params[:id].to_s
    logger.info(@observation.status)
    logger.info(@observation.valid?)
    #logger.info(observation_params)
    r = @observation.update_attributes(observation_params)
    
    logger.info(r)
    logger.info(@observation.status)
    logger.info(@observation.valid?)
    logger.info("***********************")


    jump_to params[:step]
    render_wizard @observation
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
end