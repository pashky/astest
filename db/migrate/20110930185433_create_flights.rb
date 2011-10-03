class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.integer :id
      t.integer :origin_id, :null => false
      t.integer :destination_id, :null => false
      t.date :depart_date, :null => false
      t.date :return_date, :null => false
      t.integer :value, :null => false

      t.index :origin_id, :depart_date
      t.index :destination_id
    end
  end
end
