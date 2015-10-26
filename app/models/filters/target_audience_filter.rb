class TargetAudienceFilter < Filter
  IDENTIFIER = %w(children parents nuclear_family acquaintances pregnant_woman)
  enumerize :identifier, in: TargetAudienceFilter::IDENTIFIER
end
