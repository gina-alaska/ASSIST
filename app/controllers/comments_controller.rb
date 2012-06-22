class CommentsController < ApplicationController
  respond_to :html

  def create
    comment = comment_params(params[:comment])
    @observation = Observation.find(params[:observation_id])

    @comment = @observation.comments.build comment

    if(@comment.save)
      if request.xhr?
        render json: {comment: @comment, url: observation_comment_path(@observation,@comment)}, layout: false, status: :ok
      else
        redirect_to edit_observation_url(@comment.observation)
      end
    else
      if request.xhr?
        render :json => @comment.errors, :layout => false, :status => :unprocessable_entity
      else
        render edit_observation_url(@comment.observation_id), :status => :unprocessable_entity
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      if request.xhr?
        render :json => {:success => true}, :status => :ok
      end
    end
  end

  def show
    @comment = Comment.find(params[:id])
    @observation = @comment.observation

    if request.xhr?
      render @comment, :layout => false
    else
      respond_with @comment, @observation
    end
  end

protected
  def comment_params p
    p.slice(:user_id, :data)
  end
end
