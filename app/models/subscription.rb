# Newsletter Subscription
class Subscription < ApplicationRecord
  # Validations
  validates :email, format: Email::FORMAT
end
