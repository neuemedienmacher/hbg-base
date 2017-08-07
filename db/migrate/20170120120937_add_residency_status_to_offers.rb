class AddResidencyStatusToOffers < ActiveRecord::Migration[4.2]
  def change
    add_column :offers, :residency_status, :string, null: true
  end
end
