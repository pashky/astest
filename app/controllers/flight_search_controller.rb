class FlightSearchController < ApplicationController
  respond_to :json
  
  def search

    origin_query = params[:from]
    
    origin = Airport.where("code = :q OR name LIKE concat('%', :q,'%')", { :q => origin_query }) \
      .order(:name) \
      .first
    
    if origin.nil?
      render :nothing => true, :status => :not_found
    else
      begin
        start_date = Date.parse(params[:date] || Date.today.to_s)
        
        case params[:period] || "month"
        when 'month'
          end_date = start_date.months_since(1)
        when 'season'
          end_date = start_date.months_since(4)
        else
          render :nothing => true, :status => :bad_request
          return
        end

        flightSlice = Flight.where(:origin_id => origin.id, :depart_date => start_date .. end_date)

        weeks = params[:weeks].to_i
        if weeks > 0 
          flightSlice = flightSlice.where(["floor(datediff(return_date, depart_date) / 7.0) = ?", weeks])
        end

        # no subqueries support is available in arel
        
        @results = flightSlice \
          .where("NOT EXISTS (SELECT 1 FROM (" + flightSlice.to_sql + ") f WHERE f.destination_id = flights.destination_id AND f.value < flights.value)") \
          .includes(:destination) \
          .order(:value) \

        respond_with(@results)
      rescue ArgumentError
        render :nothing => true, :status => :bad_request
      end
    end

  end

end
