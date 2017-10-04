class ChangeOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :priority, :boolean, default: false, null: false
  end
end
