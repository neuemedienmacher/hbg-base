class AddNewStampGendersToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :first_part_of_stamp, :string
    add_column :offers, :second_part_of_stamp, :string
  end
end
