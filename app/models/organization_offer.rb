# Connector model
class OrganizationOffer < ApplicationRecord
  belongs_to :offer
  belongs_to :organization, counter_cache: :offers_count
end
