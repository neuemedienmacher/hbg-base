# Bounding Box around an area that a non-personal offer provides service to.
class Area < ApplicationRecord
  # Associations
  has_many :offers, inverse_of: :area, dependent: :nullify
  has_many :divisions, inverse_of: :area, dependent: :nullify
  # Validations moved to claradmin
end
