class Absence < ApplicationRecord
  # Associations
  belongs_to :user, inverse_of: :absences
end
