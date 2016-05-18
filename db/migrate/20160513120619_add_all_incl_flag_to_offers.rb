class AddAllInclFlagToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :all_inclusive, :boolean, default: false
  end
end
