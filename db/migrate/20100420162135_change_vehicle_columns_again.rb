class ChangeVehicleColumnsAgain < ActiveRecord::Migration
  def self.up
    change_column :vehicles, :needs_assignment, :string
    change_column :vehicles, :not_dr_vehicle, :string
  end

  def self.down
    change_column :vehicles, :not_dr_vehicle, :integer
    change_column :vehicles, :needs_assignment, :integer
  end
end