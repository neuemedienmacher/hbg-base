class RemoveCategoriesFiltersAndCategoriesSectionFilters < ActiveRecord::Migration
  def change
    drop_table :categories_filters
  end
end
