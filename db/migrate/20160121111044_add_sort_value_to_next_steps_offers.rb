class AddSortValueToNextStepsOffers < ActiveRecord::Migration[4.2]
  def change
    add_column :next_steps_offers, :sort_value, :integer, default: 0
  end
end
