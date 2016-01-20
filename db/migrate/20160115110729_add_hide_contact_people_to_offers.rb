class AddHideContactPeopleToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :hide_contact_people, :boolean, default: false
  end
end
