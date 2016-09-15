class ChangeUnreachableBoolToUnreachableCount< ActiveRecord::Migration
  def change
    add_column :websites, :unreachable_count, :integer, null: false, default: 0
    remove_column :websites, :unreachable, :boolean
  end
end
