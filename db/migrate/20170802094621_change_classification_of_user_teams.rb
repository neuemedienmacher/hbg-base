class ChangeClassificationOfUserTeams < ActiveRecord::Migration[4.2]
  def change
    change_column :user_teams, :classification, :string, null: true
  end
end
