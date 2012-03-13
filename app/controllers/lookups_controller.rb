class LookupsController < ApplicationController
  respond_to :html
  def show
    @controller = params[:id]
    if request.xhr?
      render :show, :layout => false
    else
      render :show
    end

  end
end
