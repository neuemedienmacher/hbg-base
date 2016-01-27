class IncreaseIdentifierLimitOnFilters < ActiveRecord::Migration
  def up
    change_column :filters, :identifier, :string, limit: 35
  end

  def down
    change_column :filters, :identifier, :string, limit: 20
  end
end
