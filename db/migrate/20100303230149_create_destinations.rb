class CreateDestinations < ActiveRecord::Migration
  def self.up
    create_table :destinations do |t|
      t.string :place
      t.string :letter
      t.string :color

      t.timestamps
    end
  end

  def self.down
    drop_table :destinations
  end
end
