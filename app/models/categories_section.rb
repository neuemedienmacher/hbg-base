class CategoriesSection < ApplicationRecord
  belongs_to :section, inverse_of: :categories_sections
  belongs_to :category, inverse_of: :categories_sections
end
