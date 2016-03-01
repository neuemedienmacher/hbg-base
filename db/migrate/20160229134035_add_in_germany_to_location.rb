class AddInGermanyToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :in_germany, :boolean, default: true
  end
end
