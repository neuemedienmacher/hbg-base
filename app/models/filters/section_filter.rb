class SectionFilter < Filter
  # Associtations
  has_many :organizations, through: :offers
  has_and_belongs_to_many :categories

  IDENTIFIER = %w(family refugees)
  enumerize :identifier, in: SectionFilter::IDENTIFIER
end
