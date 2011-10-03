class FlightSearchController < ApplicationController
  respond_to :json
  
  def search
    respond_with FlightSearch.find_by_cheapest({
                                                 :from => params[:from],
                                                 :period => params[:period],
                                                 :weeks => params[:weeks],
                                                 :date => params[:date]
                                               })
  end

end
