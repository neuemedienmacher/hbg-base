class ChangeClassificationOfUserTeams < ActiveRecord::Migration
  def change
    change_column :user_teams, :classification, :string, null: true
  end
end
