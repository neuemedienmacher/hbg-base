class ContactPersonTranslation < ActiveRecord::Base
  include BaseTranslation

  # Concerns
  include Assignable

  # Associations
  belongs_to :contact_person, inverse_of: :translations
  has_many :section_filters, through: :contact_person
end
