class RenameVehiclesNeedsAssignmentToFirmAssignment < ActiveRecord::Migration
  def self.up
    rename_column :vehicles, :needs_assignment, :firm_assignment
  end

  def self.down
    rename_column :vehicles, :firm_assignment, :needs_assignment
  end
end