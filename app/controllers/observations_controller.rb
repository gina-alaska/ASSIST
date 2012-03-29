class ObservationsController < ApplicationController
  respond_to :html, :csv, :json, :zip

  def index
   # @observations = Observation.find(params[:ids])
    @observations ||= Observation.all


    respond_with @observations do |format|
      format.html
      format.csv 
      format.zip do 
        Observation.zip!
        send_file Rails.root.join(Observation.path, "FinalizedObservations.zip")
      end
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
        format.csv
        format.zip do
          @observation.zip!
          send_file Rails.root.join(@observation.path, "#{@observation.name}.zip")
        end
      end
    end
  end

  def manage

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
end