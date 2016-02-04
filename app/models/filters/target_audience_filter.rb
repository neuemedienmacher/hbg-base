class TargetAudienceFilter < Filter
  # Associtations
  belongs_to :section_filter

  IDENTIFIER = %w(children parents nuclear_family acquaintances pregnant_woman
                  everyone refugees_general refugees_children
                  refugees_adolescents refugees_children_and_adolescents
                  refugees_umf refugees_ujf refugees_families
                  refugees_pre_asylum_procedure refugees_asylum_procedure
                  refugees_deportation_decision refugees_toleration_decision
                  refugees_residence_permit refugees_registered refugees_parents)
  enumerize :identifier, in: TargetAudienceFilter::IDENTIFIER
end
