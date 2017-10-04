class RemoveLegalInformationFromOffers < ActiveRecord::Migration[4.2]
  def change
    remove_column :offers, :legal_information
  end
end
