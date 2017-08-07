class AddFiltersToOrganizations < ActiveRecord::Migration[4.2]
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

    # names for umbrella_filters (needed because we want to remove the locale entries)
    names = {
      :caritas=>"Caritas",
      :diakonie=>"Diakonie",
      :awo=>"Arbeiterwohlfahrt",
      :dpw=>"Deutscher Paritätischer Wohlfahrtsverband",
      :drk=>"Deutsches Rotes Kreuz",
      :asb=>"Arbeiter-Samariter-Bund",
      :zwst=>"Zentralwohlfahrtsstelle der Juden in Deutschland",
      :dbs=>"Deutscher Blinden- und Sehbehindertenverband",
      :vdw=>"Verband deutscher Wohltätigkeitsstiftungen",
      :bags=>"Bundesarbeitsgemeinschaft SELBSTHILFE von Menschen mit Behinderun und chronischer Erkrankung und ihren Angehörigen",
      :svdkd=>"Sozialverband VdK Deutschland",
      :bkd=>"Bund der Kriegsblinden Deutschlands",
      :church=>"Kirche",
      :hospital=>"Krankenhaus",
      :public=>"Öffentliche Hand",
      :other_or_none=>"Sonstige oder keine"
    }

    # create UmbrellaFilters
    UmbrellaFilter::IDENTIFIER.each do |filter_identifier|
      UmbrellaFilter.create identifier: filter_identifier, name: names[filter_identifier.to_sym]
    end

    # transfer current data (umbrella field) to umbrella_filters
    Organization.find_each do |orga|
      # empty umbrella fields get the 'other_or_none' umbrella_filter
      identifier = (orga.umbrella.blank? || orga.umbrella == 'other') ? 'other_or_none' : orga.umbrella
      # find and add UmbrellaFilter
      orga.umbrella_filters << UmbrellaFilter.find_by(identifier: identifier)
    end

    # remove umbrella field from organizations
    remove_column :organizations, :umbrella
  end
end
