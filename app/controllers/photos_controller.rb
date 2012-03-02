class PhotosController < ApplicationController
  def create
    photo = params[:photo]
    uploaded_file = photo.delete(:data)

    @observation = Observation.find(params[:observation_id])
    @photo = @observation.photos.build photo
    @photo.name = uploaded_file.original_filename

    FileUtils.mkdir_p(Rails.root.join('public', 'uploads', "observation_#{@photo.observation_id}"))

    File.open(Rails.root.join('public', 'uploads', "observation_#{@photo.observation_id}", uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end

    if(@photo.save)
      if request.xhr?
        render 'photos/uploaded', :layout => false, :status => :created, :locals => {:uploaded => @photo}
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

  def destroy
    @photo = Photo.find(params[:id])

    if @photo.destroy
      if request.xhr?
        render :json => {:success => true}, :status => :ok
      end
    end
  end
end
