class AddFiltersToOrganizations < ActiveRecord::Migration
  class Organizations < ActiveRecord::Base
    extend Enumerize
    enumerize :umbrella, in: %w(caritas diakonie awo dpw drk asb zwst dbs vdw bags
                                svdkd bkd church hospital public other)
  end

  def change
    # create new filter table
    create_table "filters_organizations", id: false, force: true do |t|
      t.integer "filter_id", null: false
      t.integer "organization_id",  null: false
    end

    # add indizes
    add_index "filters_organizations", ["filter_id"], name: "index_filters_organizations_on_filter_id", using: :btree
    add_index "filters_organizations", ["organization_id"], name: "index_filters_organizations_on_organization_id", using: :btree

    # create UmbrellaFilters
    UmbrellaFilter::IDENTIFIER.each do |filter_identifier|
      UmbrellaFilter.create identifier: filter_identifier, name: I18n.t("de.enumerize.organization.umbrella.#{filter_identifier}")
    end

    # transfer current data (umbrella field) to umbrella_filters
    Organization.find_each do |orga|
      # empty umbrella fields get the 'other' umbrella_filter
      identifier = orga.umbrella.blank? ? 'other' : orga.umbrella
      # find and add UmbrellaFilter
      orga.umbrella_filters << UmbrellaFilter.find_by(identifier: identifier)
    end

    # remove umbrella field from organizations
    remove_column :organizations, :umbrella
  end
end
