class Flight < ActiveRecord::Base
  belongs_to :origin, :class_name => "Airport"
  belongs_to :destination, :class_name => "Airport"

  scope :from_origin_in_period, lambda {|origin,start_date,end_date| where(:origin_id => origin.id, :depart_date => start_date .. end_date)}

  # mysql stuff
  scope :return_weeks, lambda {|weeks| where(["floor(datediff(return_date, depart_date) / 7.0) = ?", weeks])}

  def self.cheapest_by_destination
    # mysql too
    where("NOT EXISTS (SELECT 1 FROM (" + scoped.to_sql + ") f WHERE f.destination_id = flights.destination_id AND f.value < flights.value)")
  end
    
  def as_json(options={})
    {
      :destination => { :id => destination.id, :name => destination.name, :code => destination.code, :latitude => destination.latitude, :longitude => destination.longitude },
      :price => { :value => value, :depart_date => depart_date, :return_date => return_date }
    }
  end
end
