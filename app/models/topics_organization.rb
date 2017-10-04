# Used internally by researchers to provide extra searchable tags&keywords to offers.
class TopicsOrganization < ApplicationRecord
  # Associations
  belongs_to :topic
  belongs_to :organization
end
