class RemoveCategoriesFiltersAndCategoriesSectionFilters < ActiveRecord::Migration[4.2]
  def change
    if ActiveRecord::Base.connection.table_exists? 'categories_filters'
      drop_table :categories_filters
    end
  end
end
