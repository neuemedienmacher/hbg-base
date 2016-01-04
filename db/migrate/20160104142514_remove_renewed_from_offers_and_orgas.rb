class RemoveRenewedFromOffersAndOrgas < ActiveRecord::Migration
  def change
    remove_column :offers, :renewed, :boolean
    remove_column :organizations, :renewed, :boolean
  end
end
