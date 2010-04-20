class ChangeVehicleColumns < ActiveRecord::Migration
  def self.up
    remove_column :vehicles, :order
    remove_column :vehicles, :DR_vehicle  
    add_column :vehicles, :not_dr_vehicle, :integer
    change_column :vehicles, :needs_assignment, :integer
  end

  def self.down
    change_column :vehicles, :needs_assignment, :string
    add_column :vehicles, :dr_vehicle, :integer
    remove_column :vehicles, :not_dr_vehicle
  end
end