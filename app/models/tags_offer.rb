# Used internally by researchers to provide extra searchable keywords to offers.
class TagsOffer < ApplicationRecord
  # Associations
  belongs_to :offer
  belongs_to :tag
end
