class AddClassificationToUserTeams < ActiveRecord::Migration[4.2]
  def change
    add_column :user_teams, :classification, :string, default: 'researcher'
  end
end
