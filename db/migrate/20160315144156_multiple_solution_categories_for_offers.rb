class MultipleSolutionCategoriesForOffers < ActiveRecord::Migration
  def up
    # TODO references or integer + index?
    create_table :offers_solution_categories, :id => false do |t|
      t.references :offer, :solution_category
    end

    # define the old belongs_to category associate
    Offer.class_eval do
      belongs_to :old_solution_category,
                 :class_name => "SolutionCategory",
                 :foreign_key => "solution_category_id"
    end

    # add the belongs_to category to the has_and_belongs_to_many categories
    Offer.all.each do | offer |
      unless offer.old_solution_category.nil?
        offer.solution_categories << offer.old_solution_category
        offer.save
      end
    end

    # remove the old category_id column for the belongs_to associate
    remove_column :offers, :solution_category_id
  end

  def down
    add_column :offers, :solution_category_id, :integer
    add_index :offers, [:solution_category_id]

    Offer.class_eval do
      belongs_to :solution_category,
                 :class_name => "SolutionCategory",
                 :foreign_key => "solution_category_id"
    end

    Offer.all.each do | offer |
      # NOTE: we'll grab the first category (if present), so if there are more, these will be lost!
      offer.solution_category = offer.solution_categories.first unless offer.solution_categories.empty?
      offer.save
    end

    drop_table :offers_solution_categories
  end
end
