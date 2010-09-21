class CreateTrips < ActiveRecord::Migration
  def self.up
    create_table :trips do |t|
      t.datetime :date
      t.string :contact
      t.string :community
      t.string :preferred_vehicle
      t.integer :travelers
      t.string :destination
      t.text :notes
      t.time :depart
      t.time :return

      t.timestamps
    end

    add_index :trips, :date
    add_index :trips, :destination
  end

  def self.down
    drop_table :trips
  end
end
