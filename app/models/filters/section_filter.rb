class SectionFilter < Filter
  IDENTIFIER = %w(family refugees)
  enumerize :identifier, in: SectionFilter::IDENTIFIER
end
