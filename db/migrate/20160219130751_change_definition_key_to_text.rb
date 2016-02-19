class ChangeDefinitionKeyToText < ActiveRecord::Migration
  def change
    change_column :definitions, :key, :text, null: false, limit: 400
  end
end
