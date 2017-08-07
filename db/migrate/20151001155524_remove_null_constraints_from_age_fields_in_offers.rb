class RemoveNullConstraintsFromAgeFieldsInOffers < ActiveRecord::Migration[4.2]
  def change
    change_column :offers, :age_from, :integer, null: true
    change_column :offers, :age_to, :integer, null: true
  end
end
