class TargetAudienceFilter < Filter
  # Associations
  # should always remain a single reference (no habtm or hmt)!!
  belongs_to :section_filter

  # TODO: remove family_pregnant_woman after conversion of data!!
  FAMILY_IDENTIFIER = %w(family_children family_parents family_nuclear_family
                         family_acquaintances family_everyone
                         family_parents_to_be).freeze
  REFUGEES_IDENTIFIER =
    %w(refugees_children refugees_adolescents refugees_children_and_adolescents
       refugees_umf refugees_ujf refugees_families refugees_pre_asylum_procedure
       refugees_asylum_procedure refugees_deportation_decision
       refugees_toleration_decision refugees_residence_permit refugees_parents
       refugees_general).freeze

  IDENTIFIER = FAMILY_IDENTIFIER + REFUGEES_IDENTIFIER

  enumerize :identifier, in: TargetAudienceFilter::IDENTIFIER
end
