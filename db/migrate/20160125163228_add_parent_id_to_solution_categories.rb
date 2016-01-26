class AddParentIdToSolutionCategories < ActiveRecord::Migration
  def change
    add_column :solution_categories, :parent_id, :integer
  end
end
