class AddFarsiTextToNextStepsAndCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :next_steps, :text_fa, :string
    add_column :categories, :name_fa, :string
  end
end
