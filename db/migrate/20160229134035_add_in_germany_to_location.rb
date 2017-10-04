class AddInGermanyToLocation < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :in_germany, :boolean, default: true
  end
end
