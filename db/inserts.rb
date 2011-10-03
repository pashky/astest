#!/usr/bin/ruby
# Generate lots of csv data for mysql's LOAD DATA INFILE  
#
require 'rubygems'
gem 'backports'
require 'backports'
require 'csv'

airport_id = 0
File.open('sql-airports.dat', 'w') do |f|
  CSV.foreach(File.dirname(__FILE__) + "/airports.csv") do |ap|
    code = ap[4..5].select {|c| !c.empty? && c!="\\N"}.first
    unless code.nil?
      name = ap[1..2].reverse.select {|n| !n.empty?}.join(" - ").gsub(/,/, '')
      latitude = ap[6]
      longitude = ap[7]
      f.puts "#{airport_id + 1},#{name},#{code},#{latitude},#{longitude}\n"
      airport_id += 1
    end
  end
end

puts "Airports: #{airport_id}\n"

##########################

srand 12345

def randr(from,to)
  to > from ? from + rand(1 + to - from) : from
end

def rand_date
  Date.ordinal 2011, randr(1,365)
end

flight_id = 1
File.open('sql-flights.dat', 'w') do |f|
  airport_id.times do |origin_id|
    puts "Airport #{origin_id}\n"
    destination_ids = airport_id.times.collect.sample(randr(10,400))
    destination_ids.each do |destination_id|
      randr(10,100).times do
        departs_at = rand_date
        returns_at = departs_at + [7,14,21,28].sample
        weeks = (returns_at - departs_at).to_i / 7
        value = randr(10,1000)
        f.puts "#{flight_id},#{origin_id + 1},#{destination_id + 1},#{departs_at.to_s},#{returns_at.to_s},#{value},#{weeks}\n"
        flight_id += 1
      end
    end
  end
end

