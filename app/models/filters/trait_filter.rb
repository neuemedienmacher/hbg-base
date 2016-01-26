# Additional traits
class TraitFilter < Filter
  IDENTIFIER = %w(anonymous free confidential)
  enumerize :identifier, in: TraitFilter::IDENTIFIER
end
