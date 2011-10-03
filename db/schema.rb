# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110930185433) do

  create_table "airports", :force => true do |t|
    t.string  "name",                                    :null => false
    t.string  "code",                                    :null => false
    t.decimal "latitude",  :precision => 9, :scale => 6, :null => false
    t.decimal "longitude", :precision => 9, :scale => 6, :null => false
  end

  add_index "airports", ["code"], :name => "index_airports_on_code"
  add_index "airports", ["name"], :name => "index_airports_on_name"

  create_table "flights", :force => true do |t|
    t.integer "origin_id",      :null => false
    t.integer "destination_id", :null => false
    t.date    "depart_date",    :null => false
    t.date    "return_date",    :null => false
    t.integer "value",          :null => false
  end

  add_index "flights", ["destination_id"], :name => "index_flights_on_destination_id"
  add_index "flights", ["origin_id", "depart_date"], :name => "index_flights_on_origin_id_and_depart_date"

end
