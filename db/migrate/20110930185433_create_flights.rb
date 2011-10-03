class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.integer :id
      t.integer :origin_id, :null => false
      t.integer :destination_id, :null => false
      t.date :depart_date, :null => false
      t.date :return_date, :null => false
      t.integer :value, :null => false
    end
    add_index :flights, [:origin_id, :depart_date]
    add_index :flights, :destination_id
  end
end
