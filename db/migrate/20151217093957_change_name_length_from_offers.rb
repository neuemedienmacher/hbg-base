class ChangeNameLengthFromOffers < ActiveRecord::Migration
  def up
    change_column :offers, :name, :string, limit: 120, null: false
  end

  def down
    change_column :offers, :name, :string, limit: 80, null: false
  end
end
