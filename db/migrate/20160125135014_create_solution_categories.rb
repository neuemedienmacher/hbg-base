class CreateSolutionCategories < ActiveRecord::Migration
  def change
    create_table :solution_categories do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :solution_category_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :solution_category_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "solution_category_anc_desc_idx"

    add_index :solution_category_hierarchies, [:descendant_id],
      name: "solution_category_desc_idx"

    add_column :offers, :solution_category_id, :integer
    add_index :offers, [:solution_category_id]
  end
end
