class UsersController < ApplicationController
  respond_to :html, :except => :create

  def new
    @user = User.new

    respond_with @user
  end

  def create
    @user = User.new params[:user]

    if @user.save
      respond_with do |format|
        format.html do
          if request.xhr?
            render :json => @user, :layout => false, :status => :created
          else
            redirect_to :root
          end
        end
      end
    else
      respond_with do |format|
        format.html do
          if request.xhr?
            render :json => @user.errors, :status => :unprocessable_entity
          else
            render :action => :new, :status => :unprocessable_entity
          end
        end
      end
    end
  end
end