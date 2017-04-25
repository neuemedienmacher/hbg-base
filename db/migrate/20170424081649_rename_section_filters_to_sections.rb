class RenameSectionFiltersToSections < ActiveRecord::Migration
  def change
    rename_table :section_filters, :sections
    rename_table :categories_filters, :categories_sections
    rename_column :categories_sections, :filter_id, :section_id
    rename_column :divisions, :section_filter_id, :section_id
    rename_column :filters, :section_filter_id, :section_id
    rename_column :offers, :section_filter_id, :section_id

    add_index :categories_sections, :category_id
    add_index :categories_sections, :section_id
    add_index :divisions, :section_id
    add_index :offers, :section_id
  end

  CategoriesSection.find_each do |c|
    new_id = c.filter_id == 76 ? 1 : 2
    c.update_columns id: new_id
  end

end
