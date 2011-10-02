class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.integer :id
      t.integer :origin_id
      t.integer :destination_id
      t.date :depart_date
      t.date :return_date
      t.integer :value

      t.timestamps
    end
  end
end
