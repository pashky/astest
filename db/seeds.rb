# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
require 'csv'
airports = {}

CSV.read(File.dirname(__FILE__) + "/airports.csv").map { |ap|
  {
    :name => ap[1..2].select {|n| !n.empty?}.join(" - "),
    :code => ap[4..5].select {|c| !c.empty? && c!="\\N"}.first,
    :latitude => ap[6], :longitude => ap[7]
  }
}.each {|a| airports[a[:code]] = a unless a[:code].nil? }

Airport.create(airports.values) 

