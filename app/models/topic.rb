# Used internally by researchers to provide extra searchable tags&keywords to offers.
class Topic < ActiveRecord::Base
  # Associations
  has_many :topics_organizations
  has_many :organizations, through: :topics_organizations
end
