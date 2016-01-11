# Connector model NextStep <-> Offer
class NextStepsOffer < ActiveRecord::Base
  # Associations
  belongs_to :offer, inverse_of: :next_steps_offers
  belongs_to :next_step, inverse_of: :next_steps_offers
end
