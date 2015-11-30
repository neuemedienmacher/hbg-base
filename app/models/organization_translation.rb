class OrganizationTranslation < ActiveRecord::Base
  include BaseTranslation

  belongs_to :organization, inverse_of: :translations
end
