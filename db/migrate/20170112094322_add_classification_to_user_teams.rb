class AddClassificationToUserTeams < ActiveRecord::Migration
  def change
    add_column :user_teams, :classification, :string, default: 'researcher'
  end
end
