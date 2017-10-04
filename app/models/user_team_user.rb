# Connector model User <-> UserTeam
class UserTeamUser < ApplicationRecord
  # Associations
  belongs_to :user, inverse_of: :user_team_users
  belongs_to :user_team, inverse_of: :user_team_users
end
