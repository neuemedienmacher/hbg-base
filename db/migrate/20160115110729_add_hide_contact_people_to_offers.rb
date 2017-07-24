class AddHideContactPeopleToOffers < ActiveRecord::Migration[4.2]
  def change
    add_column :offers, :hide_contact_people, :boolean, default: false
  end
end
