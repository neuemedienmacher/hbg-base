# Represents a pending gengo order (includes translations)
class GengoOrder < ActiveRecord::Base
  # Validations
  validates :order_id, presence: true, uniqueness: true
  validates :expected_slug, presence: true
end
