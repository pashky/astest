class AirportsController < ApplicationController
  respond_to :json
  def index
    respond_with(@airports = Airport.all)
  end
end
