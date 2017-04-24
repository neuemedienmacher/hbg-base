class AddSectionFilterIdToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :section_filter_id, :integer

    Offer.find_each do |offer|
      offer.section_filter_id = offer.section_filters.first.id
    end

  end
end
