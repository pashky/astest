class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.integer :id
      t.string :name
      t.string :code
      t.decimal :latitude, :precision => 9, :scale => 6
      t.decimal :longitude, :precision => 9, :scale => 6

      t.timestamps
    end
  end
end
