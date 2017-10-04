class AddSolutionSpecificsToOffers < ActiveRecord::Migration[4.2]
  def change
    add_column :offers, :treatment_type, :string
    add_column :offers, :participant_structure, :string
  end
end
