class ChangeBaseOffers < ActiveRecord::Migration[4.2]
  def change
    drop_table :base_offers do |t|
      t.string :name
    end

    create_table :split_bases do |t|
      t.string :title, null: false
      t.string :clarat_addition
      t.text :comments
      t.integer :organization_id, null: false
      t.integer :solution_category_id, null: false
      t.timestamps null: false
    end
    add_index :split_bases, :organization_id
    add_index :split_bases, :solution_category_id

    rename_column :offers, :base_offer_id, :split_base_id
  end
end
