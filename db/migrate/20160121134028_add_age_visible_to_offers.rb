class AddAgeVisibleToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :age_visible, :boolean, default: false
  end
end
