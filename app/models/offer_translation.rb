class OfferTranslation < ActiveRecord::Base
  include BaseTranslation

  belongs_to :offer, inverse_of: :translations
end
