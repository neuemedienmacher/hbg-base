class AddCompletedInformationToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :completed_at, :datetime
    add_column :offers, :completed_by, :integer
  end
end
