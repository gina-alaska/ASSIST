class PhotosController < ApplicationController
  respond_to :html, :json, :js

  def create
    photo = params[:photo]
    uploaded_file = photo.delete(:data)

    @observation = Observation.find(params[:observation_id])
    @photo = @observation.photos.build photo
    @photo.name = uploaded_file.original_filename
    @photo.on_boat_location_lookup_id ||= OnBoatLocationLookup.where(:name => 'other').first

    FileUtils.mkdir_p( @photo.directory )

    File.open( File.join( @photo.directory, @photo.name ), 'wb') do |file|
      file.write(uploaded_file.read)
    end

    if(@photo.save)
      if request.xhr?
        render :json => @photo, :status => :ok
      else
        redirect_to edit_observation_url(@photo.observation)
      end
    else
      if request.xhr?
        render :json => @photo.errors, :layout => false, :status => :unprocessable_entity
      else
        render edit_observation_url(@photo.observation_id), :status => :unprocessable_entity
      end
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    file = File.join( @photo.directory, @photo.name );
    FileUtils.rm( file ) if File.exists? file

    if @photo.destroy
      if request.xhr?
        render :json => {:success => true}, :status => :ok
      end
    end
  end

  def show
    @photo = Photo.find(params[:id])
    @observation = @photo.observation

    if request.xhr?
      respond_with [@photo, @observation], :layout => false
    else
      respond_with @phoot, @observation
    end
  end

  def update
    @photo = Photo.find(params[:id]);

    if @photo.update_attributes(params[:photo])
      if request.xhr?
        render :json => @photo
      else
        redirect_to show_photo_url @photo
      end
    end
  end
end
