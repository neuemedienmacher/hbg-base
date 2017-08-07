class AddKewordsToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :keywords_de, :text
    add_column :categories, :keywords_en, :text
    add_column :categories, :keywords_ar, :text
    add_column :categories, :keywords_fa, :text
  end
end
