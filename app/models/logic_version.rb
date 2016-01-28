# Version of business-internal entry logic
class LogicVersion < ActiveRecord::Base
  # Associations
  has_many :offers, inverse_of: :logic_version

  # Validations
  validates :version, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
