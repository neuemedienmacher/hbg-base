class AddParentIdToSolutionCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :solution_categories, :parent_id, :integer
  end
end
