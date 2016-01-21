class AddSortValueToNextStepsOffers < ActiveRecord::Migration
  def change
    add_column :next_steps_offers, :sort_value, :integer, default: 0
  end
end
