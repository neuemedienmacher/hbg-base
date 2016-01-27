class AddNewStampGendersToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :gender_first_part_of_stamp, :string
    add_column :offers, :gender_second_part_of_stamp, :string
  end
end
