class CreateSectionFilters < ActiveRecord::Migration
  class Offer < ActiveRecord::Base
    has_and_belongs_to_many :filters
    has_and_belongs_to_many :section_filters,
                            association_foreign_key: 'filter_id',
                            join_table: 'filters_offers'

    belongs_to :section_filter
  end

  class SectionFilter < ActiveRecord::Base
  end

  def up
    create_table :section_filters do |t|
      t.string :name
      t.string :identifier

      t.timestamps null: false
    end

    add_column :offers, :section_filter_id, :integer

    fam_new_id = SectionFilter.create(name: 'Family', identifier: 'family').id
    ref_new_id = SectionFilter.create(name: 'Refugees', identifier: 'refugees').id

    Offer.find_each do |offer|
      new_id = offer.filter_ids.include?(76) ? fam_new_id : ref_new_id
      offer.section_filter_id = new_id
    end
  end

  def down
    drop_table :section_filters
    remove_column :offers, :section_filter_id
  end

  SectionFilter.create(id: 76, name: "Family", identifier: "family")
  SectionFilter.create(id: 77, name: "Refugees", identifier: "refugees")
end
