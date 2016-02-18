class TargetAudienceFilter < Filter
  # Associtations
  # should always remain a single reference (no habtm or hmt)!!
  belongs_to :section_filter

  FAMILY_IDENTIFIER = %w(family_children family_parents family_nuclear_family
                         family_acquaintances family_pregnant_woman
                         family_everyone family_pregnant_with_child)
  REFUGEES_IDENTIFIER =
    %w(refugees_children refugees_adolescents refugees_children_and_adolescents
       refugees_umf refugees_ujf refugees_families refugees_pre_asylum_procedure
       refugees_asylum_procedure refugees_deportation_decision
       refugees_toleration_decision refugees_residence_permit
       refugees_registered refugees_parents)

  IDENTIFIER = FAMILY_IDENTIFIER + REFUGEES_IDENTIFIER

  enumerize :identifier, in: TargetAudienceFilter::IDENTIFIER
end
