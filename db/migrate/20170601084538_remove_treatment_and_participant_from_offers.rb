class RemoveTreatmentAndParticipantFromOffers < ActiveRecord::Migration[4.2]
  def change
    remove_column :offers, :participant_structure
    remove_column :offers, :treatment_type
  end
end
