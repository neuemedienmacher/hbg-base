class CategoryTranslation < ActiveRecord::Base
  include BaseTranslation

  belongs_to :category, inverse_of: :translations
end
