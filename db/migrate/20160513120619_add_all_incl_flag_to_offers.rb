class AddAllInclFlagToOffers < ActiveRecord::Migration[4.2]
  def change
    add_column :offers, :all_inclusive, :boolean, default: false
  end
end
