class CreateCategoriesFilters < ActiveRecord::Migration[4.2]
  def change
    create_table :categories_filters, id: false, force: true do |t|
      t.integer "filter_id", null: false
      t.integer "category_id",  null: false
    end

    add_index "categories_filters", ["filter_id"], name: "index_filters_categories_on_filter_id", using: :btree
    add_index "categories_filters", ["category_id"], name: "index_filters_categories_on_category_id", using: :btree
  end
end
