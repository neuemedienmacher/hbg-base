class AddSolutionSpecificsToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :treatment_type, :string
    add_column :offers, :participant_structure, :string
  end
end
