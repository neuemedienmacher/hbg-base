class ChangeParticipantStructureEnumNames < ActiveRecord::Migration
  def change
    # TODO: needed or problematic?
    # class Offer < ActiveRecord::Base
    #   extend Enumerize
    #   enumerize :participant_structure, in: %w(target_audience_alone
    #     target_audience_and_others target_audience_and_others_with_same_problem)
    # end

    Offer.where(participant_structure: 'target_audience_and_others').
      update_all(participant_structure: 'target_audience_in_group_with_others_with_different_problems')

    Offer.where(participant_structure: 'target_audience_and_others_with_same_problem').
      update_all(participant_structure: 'target_audience_in_group_with_others_with_same_problem')
  end
end
