class AddDefaultsAgesToOffers < ActiveRecord::Migration
  def change
    change_column :offers, :age_from, :integer, default: 0
    change_column :offers, :age_to, :integer, default: 99
  end
end
