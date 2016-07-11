# Devise user model, only used for researchers and supervisors to access the
# backend. Not for clients yet.
class User < ActiveRecord::Base
  # Associations
  has_many :authored_notes, class_name: 'Note', inverse_of: :user
  has_many :user_team_users, inverse_of: :user
  has_many :user_teams, through: :user_team_users, inverse_of: :users

  # Validations
  # validates :email, uniqueness: true, presence: true

  # Enumerization
  extend Enumerize
  enumerize :role, in: %w(standard researcher super)

  # Scopes
  scope :researcher, -> { where(role: 'researcher') }
end
