class AddColorColumnToVehicles < ActiveRecord::Migration
  def self.up
    add_column :vehicles, :color, :string
  end

  def self.down
    remove_column :vehicles, :color
  end
end