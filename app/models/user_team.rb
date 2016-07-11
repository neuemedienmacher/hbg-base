class UserTeam < ActiveRecord::Base
  # Associations
  has_many :user_team_users, inverse_of: :user_team
  has_many :users, through: :user_team_users, inverse_of: :user_teams

  has_many :productivity_goals, inverse_of: :user_team
end
