class ChangeOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :priority, :boolean, default: false, null: false
  end
end
