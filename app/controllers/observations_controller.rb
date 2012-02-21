class ObservationsController < ApplicationController
  respond_to :html
  def new
    @observation = Observation.new
    respond_with(@observation)
  end
end
