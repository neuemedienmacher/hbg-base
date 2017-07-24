# Version of business-internal entry logic
class LogicVersion < ApplicationRecord
  # Associations
  has_many :offers, inverse_of: :logic_version

  # Validations moved to claradmin
end
