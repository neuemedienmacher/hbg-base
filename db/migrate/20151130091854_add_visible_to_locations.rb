class AddVisibleToLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :visible, :boolean, default: true
  end
end
