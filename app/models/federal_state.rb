# Normalization of (German) federal states.
class FederalState < ApplicationRecord
  # Associations
  has_many :locations, inverse_of: :federal_state

  # Validations moved to claradmin
end
