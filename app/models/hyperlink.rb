# Polymorphic join model between organizations/offers and websites.
class Hyperlink < ActiveRecord::Base
  # associtations
  belongs_to :linkable, polymorphic: true
  belongs_to :website
end
