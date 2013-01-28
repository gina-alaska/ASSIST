class ObservationsController < ApplicationController
  respond_to :html, :csv, :json, :zip

  def index
    @observations = Observation.includes(:ice, ice_observations: [:topography, :melt_pond], meteorology: [:clouds])
    
    if(observation_ids.any?)
      @observations = @obserations.where(observation_ids)
    end

    respond_with @observations do |format|
      format.html
      format.csv {render text: generate_csv(@observations)}
      format.zip do 
       # Observation.zip! @observations, name: "Observation", formats: [:csv,:json]
        generate_zip @observations, name: "Observation", formats: [:csv,:json], include_photos: params[:include_photos]
        File.open(File.join(Observation.path,"Observation.zip"), "rb") do |f|
          send_data f.read
        end
      end
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
    @observation = Observation.includes(:ice, ice_observations: [:topography, :melt_pond], meteorology: [:clouds]).where(:id => params[:id]).first
    @observation.valid?
    respond_with @observation
  end
  
  def update
    @observation = Observation.where(:id => params[:id])
    @observation = @observation.includes(:ice, ice_observations: [:topography, :melt_pond], meteorology: [:clouds])
    @observation = @observation.first
    
    obs_datetime = parse_date
    @observation.obs_datetime = obs_datetime unless obs_datetime.nil?
    
    @observation.finalize = (params[:id] == "validate")  
    
    if @observation.update_attributes(observation_params)
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
          render params[:id]
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
    @observation = Observation.includes(:ice, ice_observations: [:topography, :melt_pond], meteorology: [:clouds]).where(:id => params[:id]).first


    if request.xhr?
      respond_with @observation, :layout => false
    else
      respond_with @observation do |format|
        format.html
        format.csv {render text: generate_csv(@observation) }
        format.json {render json: @observation.to_json}
        format.zip do
          @observation.zip!
          File.open(Rails.root.join(@observation.path, "#{@observation.name}.zip"), "rb" ) do |f|
            send_data f.read
          end
        end
      end
    end
  end

  def import
    uploaded_file = params[:data]

#    mapFile = Rails.root.join("config/import_map_#{year}.yml") 
#    mapFile = File.exists?(mapFile) ? mapFile : Rails.root.join("config/import_map.yml")

 #   results = Observation.from_csv( Rails.root.join( data.tempfile.path ).to_s, mapFile.to_s )
    results = {}

    filetype = uploaded_file.content_type.split("/").last

    results = self.send("import_#{filetype}", uploaded_file)

    if request.xhr? 
      render :json => {:success => true, :results => results }
    else
      redirect_to observation_url
    end
  end
  
  def export
    @observations = Observation.includes(:ice, ice_observations: [:topography, :melt_pond], meteorology: [:clouds])
    
    if(observation_ids.any?)
      @observation = @observations.where(observation_ids).all
    end
    
    @observations.select!{|obs| obs.valid?}
    
    respond_with @observations do |format|
      format.html
      format.csv 
      format.zip do 
        generate_zip @observations, name: "Observation", formats: [:csv,:json], include_photos: params[:include_photos]
        File.open(File.join(Observation.path,"Observation.zip"), "rb") do |f|
          send_data f.read, filename: "ASSIST_#{Time.now.strftime("%Y%m%d%H%M%S")}_export.zip"
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

  def import_zip file
    results = []
    directory = "/tmp/#{File.basename(file.tempfile.path)}_zip_#{Time.now.to_i}"
    begin
      Dir.mkdir(directory) unless File.exists? directory
  
      Zip::ZipFile.open(file.tempfile) do |zipfile|
        zipfile.each do |f|
          path = File.join(directory, f.name)
          FileUtils.mkdir_p( File.dirname(path) )
          f.extract(path)
        end
      end

      Dir.chdir(directory) do |d|
        files = Dir.glob(File.join("**", "*.json"))
        files = Dir.glob(File.join("**", "*.csv")) if files.empty?
        raise "Nothing to import" if files.empty?

        files.each do |f|
          ftype = File.extname(f).slice(1..-1)
          results << Observation.send("from_#{ftype}", f)
        end
      end
    rescue => ex
      results = [{error: "Unable to import"}]
    ensure
     # FileUtils.remove(directory, :recursive => true)
    end
    results
  end

  def import_csv file
    mapFile = "config/import_map.yml"

    results = Observation.from_csv(Rails.root.join(file.tempfile.path).to_s, mapFile)
    results
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
    name = opts[:name] || "observations"
    FileUtils.mkdir_p(Observation.path) unless File.exists? Observation.path
    fullpath = File.join(Observation.path, "#{name}.zip")
    FileUtils.remove(fullpath) if File.exists?(fullpath)
  
    metadata = {
      exported_on: Time.now.utc,
      assist_version: ASSIST_VERSION,
      cruise_id: Cruise[:id],
      ship_name: Cruise[:ship],
      observation_count: observations.count,
      observations: "#{name}.json",
      photos_included: !!opts[:include_photos]
    }
    opts[:formats] ||= [:csv, :json]

    Zip::ZipFile.open(fullpath, Zip::ZipFile::CREATE) do |zipfile|
      #Add the metadata
      zipfile.file.open("METADATA", "w"){|f| f.puts metadata.to_yaml}
      
      [opts[:formats]].flatten.each do |format|
        observations.each do |obs|
          zipfile.file.open("#{obs.name}.#{format}","w"){|f| f << obs.send("to_#{format}")}
        end
        zipfile.file.open("#{name}.#{format}","w"){|f| f << observations.send("to_#{format}")}
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
end