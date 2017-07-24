# Connector model NextStep <-> Offer
class NextStepsOffer < ApplicationRecord
  # Associations
  belongs_to :offer, inverse_of: :next_steps_offers
  belongs_to :next_step, inverse_of: :next_steps_offers

  # Scopes
  default_scope { order(:sort_value, :id) }
end
