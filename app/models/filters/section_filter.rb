class SectionFilter < Filter
  # Associtations
  has_many :target_audience_filters

  IDENTIFIER = %w(family refugees).freeze
  enumerize :identifier, in: SectionFilter::IDENTIFIER
end
