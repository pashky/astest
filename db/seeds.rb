require 'csv'
airports = {}
CSV.read(File.dirname(__FILE__) + "/airports.csv").map { |ap|
  {
    :name => ap[1..2].select {|n| !n.empty?}.join(" - "),
    :code => ap[4..5].select {|c| !c.empty? && c!="\\N"}.first,
    :latitude => ap[6], :longitude => ap[7]
  }
}.each {|a| airports[a[:code]] = a unless a[:code].nil? }

puts "Creating airports"
airport_ids = Airport.create(airports.values[0..400]).map { |a| a.id }

##########################

srand 12345

def randr(from,to)
  to > from ? from + rand(1 + to - from) : from
end

def rand_date
  Date.ordinal 2011, randr(1,365)
end

airport_ids.each do |origin_id|
  puts "Airport #{origin_id}\n"
  destination_ids = airport_ids.sample(randr(10,50))
  destination_ids.each do |destination_id|
    puts "     Destination #{destination_id}\n"
    Flight.create(randr(10,50).times.collect {
                    departs_at = rand_date
                    returns_at = departs_at + [7,14,21,28].sample 
                    {
                      :origin_id => origin_id,
                      :destination_id => destination_id,
                      :depart_date => departs_at,
                      :return_date => returns_at,
                      :value => randr(10,1000)
                    }
                  })
  end
end

