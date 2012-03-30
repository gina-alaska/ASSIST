require 'digest'

class PhotosController < ApplicationController
  respond_to :html, :json, :js

  def create
    photo = params[:photo]
    uploaded_file = photo.delete(:data)

    @observation = Observation.find(params[:observation_id])
    @photo = @observation.photos.build photo
    @photo.name = uploaded_file.original_filename
    @photo.on_boat_location_lookup_id ||= OnBoatLocationLookup.where(:name => 'other').first
    uploaded_file.rewind
    @photo.checksum_id = Digest::MD5.hexdigest( "#{@observation.id}_#{uploaded_file.read}")

    if(@photo.save)
      FileUtils.mkdir_p( @photo.directory )
      logger.info( @photo.directory )
      logger.info( File.exists? @photo.directory )
      File.open( File.join( @photo.directory, @photo.name ), 'wb') do |file|
        uploaded_file.rewind
        file.write(uploaded_file.read)
      end

      if request.xhr?
        render :json => {:photo => @photo, :url => photo_path(@photo)}, :status => :ok
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
    @photo = Photo.find(params[:observation_id])
    @observation = @photo.observation

    if request.xhr?
      respond_with [@photo, @observation], :layout => false
    else
      respond_with @photo, @observation do |format|
        format.html
        format.json
        format.any do
          send_file(@photo.uri.to_s, :filename => @photo.name)
        end
      end
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
