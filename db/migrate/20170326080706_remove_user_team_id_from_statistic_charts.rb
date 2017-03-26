class RemoveUserTeamIdFromStatisticCharts < ActiveRecord::Migration
  def change
    remove_column :statistic_charts, :user_team_id
  end
end
