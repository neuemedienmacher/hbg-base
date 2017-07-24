# Connector Model ContactPeople <-> Offers
class ContactPersonOffer < ApplicationRecord
  # Associations
  belongs_to :offer, inverse_of: :contact_person_offers
  belongs_to :contact_person, inverse_of: :contact_person_offers

  # Validations
end
