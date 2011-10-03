class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.integer :id
      t.string :name, :null => false, :unique => false
      t.string :code, :null => false, :unique => true
      t.decimal :latitude, :precision => 9, :scale => 6, :null => false
      t.decimal :longitude, :precision => 9, :scale => 6, :null => false

      t.index :name
      t.index :code
    end
  end
end
