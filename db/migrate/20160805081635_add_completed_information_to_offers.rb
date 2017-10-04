class AddCompletedInformationToOffers < ActiveRecord::Migration[4.2]
  def change
    add_column :offers, :completed_at, :datetime
    add_column :offers, :completed_by, :integer
  end
end
