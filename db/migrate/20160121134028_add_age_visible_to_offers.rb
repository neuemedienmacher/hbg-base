class AddAgeVisibleToOffers < ActiveRecord::Migration[4.2]
  def change
    add_column :offers, :age_visible, :boolean, default: false
  end
end
