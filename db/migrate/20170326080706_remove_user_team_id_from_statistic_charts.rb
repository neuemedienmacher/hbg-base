class RemoveUserTeamIdFromStatisticCharts < ActiveRecord::Migration[4.2]
  def change
    remove_column :statistic_charts, :user_team_id
  end
end
