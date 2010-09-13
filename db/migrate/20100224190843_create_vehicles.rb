class CreateVehicles < ActiveRecord::Migration
  def self.up
    create_table "vehicles", :force => true do |t|
      t.string "name"
      t.string "color"
      t.string "firm_assignment"
      t.string "not_dr_vehicle"

      t.timestamps
    end
  end

  def self.down
    drop_table :vehicles
  end
end
