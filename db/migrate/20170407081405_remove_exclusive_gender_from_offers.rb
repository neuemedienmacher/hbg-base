class RemoveExclusiveGenderFromOffers < ActiveRecord::Migration[4.2]
  def change
    remove_column :offers, :exclusive_gender, :string
  end
end
