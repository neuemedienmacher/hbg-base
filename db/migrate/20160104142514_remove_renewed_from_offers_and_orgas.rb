class RemoveRenewedFromOffersAndOrgas < ActiveRecord::Migration[4.2]
  def change
    remove_column :offers, :renewed, :boolean
    remove_column :organizations, :renewed, :boolean
  end
end
