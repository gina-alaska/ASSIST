class PhotosController < ApplicationController
  def create
    uploaded_file = params[:photo].delete(:data)
    @photo = Photo.new(params[:photo])
    @photo.name = uploaded_file.original_filename

    FileUtils.mkdir_p(Rails.root.join('public', 'uploads', "observation_#{@photo.observation_id}"))

    File.open(Rails.root.join('public', 'uploads', "observation_#{@photo.observation_id}", uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end

    if(@photo.save)
      if request.xhr?
        render :json => @photo, :layout => false, :status => :created
      else
        redirect_to edit_observation_url(@photo.observation)
      end
    else
      if request.xhr?
        render :json => @photo.errors, :layout => false, :status => :unprocessable_entity
      end
        render edit_observation_url(@photo.observation_id), :status => :unprocessable_entity
    end
  end
end
