class ObservationsController < ApplicationController
  respond_to :html

  def index
    @observations = Observation.all
    respond_with @observations
  end

  def new
    @observation = Observation.new
    respond_with(@observation)
  end

  def create
    @observation = Observation.new params[:observation]

    if @observation.save!
      respond_with @observation do |format|
        format.html { render :action => :edit}
      end
    end
  end

  def edit
    @observation = Observation.where(:id => params[:id]).first
    @observation.build_ice if @observation.ice.nil?
    @observation.build_meteorology if @observation.meteorology.nil?
    respond_with @observation
  end
end
