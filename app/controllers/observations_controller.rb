require 'net/http'

class ObservationsController < ApplicationController
  respond_to :html, :csv, :json, :zip
  before_filter :load_cruise_info
  
  def index
    @observations = Observation.includes(:ice, ice_observations: [:topography, :melt_pond], meteorology: [:clouds])

    if(observation_ids.any?)
      @observations = @obserations.where(observation_ids)
    end

    respond_with @observations do |format|
      format.html 
    end
  end

  def new
    @observation = Observation.new
  end

  def create
    obs = params[:observation]
    @observation = Observation.new obs
    @observation.obs_datetime = Time.now
    @observation.finalize = false
    #Don't validate on create,  it will never be valid.
    if @observation.save
      respond_to do |format|
        format.html { redirect_to edit_observation_path(@observation) }
      end
    else
      render :new
    end
  end

  def edit
    @observation = Observation.includes(:ice, ice_observations: [:topography, :melt_pond], meteorology: [:clouds]).where(:id => observation_id).first
    @observation.valid?
    @observation.faunas.build
    respond_with @observation
  end
  
  def update
    @observation = Observation.where(:id => observation_id)
    @observation = @observation.includes(:ice, ice_observations: [:topography, :melt_pond], meteorology: [:clouds])
    @observation = @observation.first
    
    obs_datetime = parse_date
    @observation.obs_datetime = obs_datetime unless obs_datetime.nil?
    
    @observation.finalize = (params[:id] == "validate")  
    
    if @observation.update_attributes(observation_params)
      %w{json csv}.each do |format |
        save_to_disk(observation_url(@observation, format), @observation.export_name(format))
      end
      if request.xhr?
        respond_to do |format|
          if params[:commit] == "Save and Exit"
            format.js{ render js: "window.location = '#{root_url}'"}
          else
            format.js{ render layout: false }
          end
        end
      else
        if params[:commit] == "Save and Exit"
          redirect_to root_url          
        else
          render 'edit' #@observation
        end
      end
    else
      if request.xhr?
        respond_to do |format|
          format.html {render partial: 'shared/errors', model: @observation, layout: false }
          format.json {render json: {success: false, path: edit_observation_path(@observation)}, layout: false}
        end
      else
        render @observation
      end
    end   
  end

  def show
    @observation = Observation.includes(:ice, ice_observations: [:topography, :melt_pond], meteorology: [:clouds]).where(:id => observation_id).first

    if request.xhr?
      respond_with @observation, :layout => false
    else
      respond_with @observation do |format|
        format.html
        format.json 
        format.csv {render text: generate_csv(@observation) }
      end
    end
  end

  def import
    @imports = ImportObservation.new(file: params[:data])
    
    if @imports.save
      render action: :import, layout: !request.xhr?
    else
      render action: :import, layout: !request.xhr?, error: "There was an error importing records", status: :unprocessable_entity
    end
  end
  
  def export
    @observations = Observation.includes(:ice, ice_observations: [:topography, :melt_pond], meteorology: [:clouds])
    cruise_info = CruiseInfo.first
    if(observation_ids.any?)
      Rails.logger.info(observation_ids)
      @observations = @observations.where(observation_ids)
    end

    @export_name = [cruise_info.ship, Time.now.utc.strftime("%Y%m%d%H%M"), @observations.count].join("_")
    
    respond_with @observations do |format|
      format.html
      format.csv 
      format.zip do 
        generate_zip @observations, include_photos: params[:include_photos]
        File.open(File.join(EXPORT_DIR, "#{@export_name}.zip"), "rb") do |f|
          send_data f.read, filename: "#{@export_name}.zip"
        end
      end
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
    p
  end
  def observation_id
    params[:id].split("-").last
  end

  def observation_ids 
    params.slice(:id)
  end
  
  def generate_csv observations
    observations = [observations].flatten
    ::CSV.generate({:headers => true}) do |csv|
      csv << Observation.headers
      observations.each do |o|
        csv << o.as_csv
      end
    end
  end    
  
  def generate_zip observations, opts={}
    FileUtils.mkdir_p(EXPORT_DIR) unless File.exists? EXPORT_DIR
    fullpath = File.join(EXPORT_DIR, "#{@export_name}.zip")
    FileUtils.remove(fullpath) if File.exists?(fullpath)
    
    metadata = {
      exported_on: Time.now.utc,
      assist_version: ASSIST_VERSION,
      ship_name: cruise_info.ship,
      captain: cruise_info.captain,
      chief_scientist: cruise_info.chief_scientist,
      observation_count: observations.count,
      observations: "#{@export_name}.json",
      photos_included: !!opts[:include_photos]
    }
    
    #Make sure no invalid observations have snuck in
    observations.select!{|o| o.valid?}

    Zip::ZipFile.open(fullpath, Zip::ZipFile::CREATE) do |zipfile|
      #Add the metadata
      zipfile.file.open("METADATA", "w"){|f| f.puts metadata.to_yaml}
      
      ['csv','json'].flatten.each do |format|
        observations.each do |obs|
          filepath = File.join(obs.to_s,"#{obs.name}.#{format}")
          zipfile.add(filepath, File.expand_path(File.join(EXPORT_DIR,filepath)))
        end
        
        zipfile.file.open("#{@export_name}.#{format}","w") do |f| 
          f << observations.send("to_#{format}")
        end
      end
      
      if opts[:include_photos]
        observations.each do |o|
          o.photos.each do |p|
           # zipfile.add(File.join(p.observation.name,p.name), File.join( p.observation.path, p.name))
          end
        end
      end
    end
  end
  
  private
  def load_cruise_info
    @cruise = CruiseInfo.first
    
    if @cruise.nil?
      redirect_to new_cruise_infos_path
    end
  end
  
  def save_to_disk uri, filepath
    FileUtils.mkdir_p(File.dirname(filepath)) unless File.exists?(File.dirname(filepath))

    File.open(filepath, "w") do |file|
       file << Net::HTTP.get(URI.parse(uri))
    end
  end
end