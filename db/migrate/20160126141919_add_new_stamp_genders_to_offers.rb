class AddNewStampGendersToOffers < ActiveRecord::Migration[4.2]
  def change
    add_column :offers, :gender_first_part_of_stamp, :string
    add_column :offers, :gender_second_part_of_stamp, :string
  end
end
