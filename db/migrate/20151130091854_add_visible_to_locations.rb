class AddVisibleToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :visible, :boolean, default: true
  end
end
