class UsersController < ApplicationController
  respond_to :html

  def new
    @user = User.new

    respond_with @user
  end

  def create
    @user = User.new params[:user]

    if @user.save!
      redirect_to :back
    end
  end
end
