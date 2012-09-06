class ObservationsController < ApplicationController
  respond_to :html, :csv, :json, :zip

  def index
   # @observations = Observation.find(params[:ids])
    @observations = Observation.where(observation_ids).all

    @observations ||= Observation.all


    respond_with @observations do |format|
      format.html
      format.csv {render text: generate_csv(@observations)}
      format.zip do 
        Observation.zip! @observations, name: "Observation", formats: [:csv,:json]
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
    #@observation.obs_datetime = parse_date( dateFields params )
  
    #Don't validate on create,  it will never be valid.
    if @observation.save validate: false
      respond_to do |format|
        format.html { redirect_to observation_build_path(@observation, :general) }
      end
    else
      render :new
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
    @observation.obs_datetime = parse_date(dateFields(params))
 
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
      respond_with @observation do |format|
        format.html
        format.csv {render text: generate_csv(@observation) }
        format.zip do
          @observation.zip!
          File.open(Rails.root.join(@observation.path, "#{@observation.name}.zip"), "rb" ) do |f|
            send_data f.read
          end
        end
      end
    end
  end

  def manage
    @observations = Observation.all

    respond_with @observations
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
    @observations = Observation.where(observation_ids).all
    
    @observations ||= Observation.all
    
    
    respond_with @observations do |format|
      format.html
      format.csv 
      format.zip do 
        Observation.zip! @observations, name: "Observation", formats: [:csv,:json], include_photos: params[:include_photos]
        File.open(File.join(Observation.path,"Observation.zip"), "rb") do |f|
          send_data f.read, filename: "ASSIST_#{Time.now.strftime("%Y%m%d%H%M%S")}_export.zip"
        end
      end
    end    
  end
  
protected
  def parse_date arr
    begin
      DateTime.parse("#{arr[:observation_date]} #{arr[:observation_hour]}:#{arr[:observation_minute]} UTC")
    rescue
      nil
    end
  end

  def dateFields p
    p.slice(:observation_date, :observation_hour, :observation_minute)
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
          logger.info(path)
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
      logger.info ex
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

  def import_json
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
  
end