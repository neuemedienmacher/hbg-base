class AddSectionFilterIdToFilters < ActiveRecord::Migration[4.2]
  def change
    add_column :filters, :section_filter_id, :integer
    add_index :filters, :section_filter_id
  end
end
