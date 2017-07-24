class AddDescriptionToLogicVersion < ActiveRecord::Migration[4.2]
  def change
    add_column :logic_versions, :description, :text
  end
end
