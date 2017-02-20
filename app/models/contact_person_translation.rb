class ContactPersonTranslation < ActiveRecord::Base
  include BaseTranslation

  # Associations
  belongs_to :contact_person, inverse_of: :translations
end
