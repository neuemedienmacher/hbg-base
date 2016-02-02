# Additional traits
class TraitFilter < Filter
  IDENTIFIER = %w(anonymous free confidential day_and_night)
  enumerize :identifier, in: TraitFilter::IDENTIFIER
end
