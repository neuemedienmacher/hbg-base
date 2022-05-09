class TargetAudienceFilter < Filter
  # Associations
  # should always remain a single reference (no habtm or hmt)!!
  belongs_to :section, inverse_of: :target_audience_filters
  has_many :target_audience_filters_offers, dependent: :destroy
  has_many :offers, through: :target_audience_filters_offers, source: :offer

  FAMILY_IDENTIFIER = %w[family_children family_parents family_nuclear_family
                         family_relatives family_parents_to_be
                         family_everyone].freeze

  REFUGEES_IDENTIFIER = %w[refugees_children refugees_uf refugees_parents
                           refugees_families refugees_parents_to_be
                           refugees_general].freeze

  IMMIGRANTS_IDENTIFIER = %w[immigrants_children immigrants_adults immigrants_general].freeze

  IDENTIFIER = [FAMILY_IDENTIFIER, REFUGEES_IDENTIFIER, IMMIGRANTS_IDENTIFIER].reduce([], :concat)

  enumerize :identifier, in: TargetAudienceFilter::IDENTIFIER
end
