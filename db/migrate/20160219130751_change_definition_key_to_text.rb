class ChangeDefinitionKeyToText < ActiveRecord::Migration[4.2]
  def change
    change_column :definitions, :key, :text, null: false, limit: 400
  end
end
