# Hierarchical solution categories for offers.
class SolutionCategory < ActiveRecord::Base
  # Closure Tree
  has_closure_tree

  # Associations
  # has_many :offers, inverse_of: :solution_category
  has_many :solution_category_offers, inverse_of: :solution_category
  has_many :offers, through: :solution_category_offers, inverse_of: :solution_categories

  # Validations
  validates :name, presence: true

  # Sanitization
  extend Sanitization
  auto_sanitize :name

  # Methods
end
