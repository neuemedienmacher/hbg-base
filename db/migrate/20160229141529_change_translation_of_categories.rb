class ChangeTranslationOfCategories < ActiveRecord::Migration
  class CategoryTranslation < ActiveRecord::Base
    include BaseTranslation

    belongs_to :category, inverse_of: :translations
  end

  def up
    rename_column :categories, :name, :name_de
    add_column :categories, :name_en, :string
    add_column :categories, :name_ar, :string
    add_column :categories, :name_fr, :string
    add_column :categories, :name_pl, :string
    add_column :categories, :name_tr, :string
    add_column :categories, :name_ru, :string

    CategoryTranslation.find_each do |translation|
      Category.find(translation.category_id).update_column(
        :"name_#{translation.locale}" => translation.name
      )
    end

    drop_table :category_translations
  end

  def down
    create_table 'category_translations', force: :cascade do |t|
      t.integer  'category_id',              null: false
      t.string   'locale',                   null: false
      t.string   'source',      default: '', null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.string   'name',        default: '', null: false
    end

    add_index 'category_translations', ['category_id'], name: 'index_category_translations_on_category_id'
    add_index 'category_translations', ['locale'], name: 'index_category_translations_on_locale'

    Category.find_each do |category|
      unless category.name_en.blank?
        CategoryTranslation.create(
          category_id: category.id, locale: :en, name: category.name_en,
          source: 'researcher'
        )
      end
      unless category.name_ar.blank?
        CategoryTranslation.create(
          category_id: category.id, locale: :ar, name: category.name_ar,
          source: 'researcher'
        )
      end
      unless category.name_fr.blank?
        CategoryTranslation.create(
          category_id: category.id, locale: :fr, name: category.name_fr,
          source: 'researcher'
        )
      end
      unless category.name_tr.blank?
        CategoryTranslation.create(
          category_id: category.id, locale: :tr, name: category.name_tr,
          source: 'researcher'
        )
      end
      unless category.name_ru.blank?
        CategoryTranslation.create(
          category_id: category.id, locale: :ru, name: category.name_ru,
          source: 'researcher'
        )
      end
      unless category.name_pl.blank?
        CategoryTranslation.create(
          category_id: category.id, locale: :pl, name: category.name_pl,
          source: 'researcher'
        )
      end
    end

    rename_column :categories, :name_de, :name
    remove_column :categories, :name_en
    remove_column :categories, :name_ar
    remove_column :categories, :name_fr
    remove_column :categories, :name_pl
    remove_column :categories, :name_tr
    remove_column :categories, :name_ru
  end
end
