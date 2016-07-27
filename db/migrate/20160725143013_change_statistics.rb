class ChangeStatistics < ActiveRecord::Migration
  def change
    rename_column :statistics, :x, :date
    rename_column :statistics, :y, :count
    reversible do |dir|
      dir.up do
        change_column :statistics, :count, :integer, default: 0
        change_column :statistics, :topic, :string, null: true
      end
      dir.down do
        change_column :statistics, :count, :integer
        change_column :statistics, :topic, :string, limit: 40, null: false
      end
    end

    add_column :statistics, :user_team_id, :integer
    add_column :statistics, :model, :string
    add_column :statistics, :field_name, :string
    add_column :statistics, :field_start_value, :string
    add_column :statistics, :field_end_value, :string

    add_index :statistics, :user_team_id

    add_column :users, :current_team_id, :integer
    add_index :users, :current_team_id
  end
end
