class TargetAudienceFilter < Filter
  IDENTIFIER = %w(children parents nuclear_family acquintances pregnant_woman)
  enumerize :identifier, in: TargetAudienceFilter::IDENTIFIER
end
