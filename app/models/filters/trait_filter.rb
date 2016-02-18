# Additional traits
class TraitFilter < Filter
  IDENTIFIER = %w(anonymous free confidential day_and_night charged).freeze
  enumerize :identifier, in: TraitFilter::IDENTIFIER
end
