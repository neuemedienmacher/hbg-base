# Connector model NextStep <-> Offer
class NextStepsOffer < ActiveRecord::Base
  # Associations
  belongs_to :offer
  belongs_to :next_step

  # Validations
  validates :offer_id, presence: true
  validates :next_step_id, presence: true
end
