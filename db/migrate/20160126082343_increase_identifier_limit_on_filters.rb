class IncreaseIdentifierLimitOnFilters < ActiveRecord::Migration[4.2]
  def up
    change_column :filters, :identifier, :string, limit: 35
  end

  def down
    change_column :filters, :identifier, :string, limit: 20
  end
end
