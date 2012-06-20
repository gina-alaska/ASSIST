class UsersController < ApplicationController
  respond_to :html, :except => :create

  def new
    @user = User.new

    respond_with @user
  end

  def create
    @user = User.new params[:user]
    primary = params[:commit] == "Add as Primary Observer" ? true : false
    secondary = params[:commit] == "Add as Secondary Observer" ? true : false
    
    if @user.save
      respond_with do |format|
        format.html do
          if request.xhr?
            render :json => {user: @user, primary: primary, secondary: secondary, id: @user.id}, layout: false, status: :created
          else
            redirect_to :root
          end
        end
      end
    else
      respond_with do |format|
        format.html do
          if request.xhr?
            render partial: 'shared/errors', status: :unprocessable_entity, layout: false, locals: {model: @user}
          else
            render :action => :new, :status => :unprocessable_entity
          end
        end
      end
    end
  end
end