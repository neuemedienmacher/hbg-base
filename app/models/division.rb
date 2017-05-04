# Polymorphic join model between organizations/offers and websites.
class Division < ActiveRecord::Base
  # associtations
  belongs_to :organization, inverse_of: :divisions
  belongs_to :section, inverse_of: :divisions

  has_many :divisions_presumed_categories, inverse_of: :division
  has_many :presumed_categories, through: :divisions_presumed_categories,
           source: :category, inverse_of: :presuming_divisions
  has_many :divisions_presumed_solution_categories, inverse_of: :division
  has_many :presumed_solution_categories,
           through: :divisions_presumed_solution_categories,
           source: :solution_category, inverse_of: :presuming_divisions
end
