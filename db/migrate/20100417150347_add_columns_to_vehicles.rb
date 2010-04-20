class AddColumnsToVehicles < ActiveRecord::Migration
  def self.up
    add_column :vehicles, :order, :integer
    add_column :vehicles, :DR_vehicle, :boolean
    add_column :vehicles, :needs_assignment, :boolean
  end

  def self.down
    remove_column :vehicles, :needs_assignment
    remove_column :vehicles, :DR_vehicle
    remove_column :vehicles, :order
  end
end