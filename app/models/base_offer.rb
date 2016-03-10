class BaseOffer < ActiveRecord::Base
  # Associations
  has_many :offers, inverse_of: :base_offer

  # Validations
  validates :name, presence: true, uniqueness: true
end
