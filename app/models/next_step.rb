# A building block to form the "next steps" description for Offers
class NextStep < ActiveRecord::Base
  # Associations
  has_many :next_steps_offers, inverse_of: :next_step
  has_many :offers, through: :next_steps_offers, inverse_of: :next_steps

  # Validations
  validates :text_de, presence: true, length: { maximum: 255 }
  validates :text_en, length: { maximum: 255 }
  validates :text_ar, length: { maximum: 255 }
  validates :text_fr, length: { maximum: 255 }
  validates :text_pl, length: { maximum: 255 }
  validates :text_tr, length: { maximum: 255 }
  validates :text_ru, length: { maximum: 255 }

  # Methods
end
