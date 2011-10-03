class Flight < ActiveRecord::Base
  belongs_to :origin, :class_name => "Airport"
  belongs_to :destination, :class_name => "Airport"

  def as_json(options={})
    {
      :destination => { :id => destination.id, :name => destination.name, :code => destination.code, :latitude => destination.latitude, :longitude => destination.longitude },
      :price => { :value => value, :depart_date => depart_date, :return_date => return_date }
    }
  end
end
