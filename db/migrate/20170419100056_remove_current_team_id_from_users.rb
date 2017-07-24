class RemoveCurrentTeamIdFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :current_team_id
  end
end
