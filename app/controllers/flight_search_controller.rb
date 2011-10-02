class FlightSearchController < ApplicationController
  def search
    origin_name = params[:from]
    start_date = params[:date]
    period = params[:period]
    duration = params[:duration]
    
    @origin = Airport.where(:code => origina_name)

#    @"origin_id = ? AND depart_date BETWEEN ? AND ? AND datediff(return_date, depart_date) = 7", 39, "2011-05-01".to_date, "2011-05-31".to_date,
#                            { :c)
    
    respond_to do |format|
      format.json { render :json => @origin }
    end
  end

end
