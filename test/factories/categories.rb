require 'ffaker'

FactoryGirl.define do
  factory :category do
    name_de { FFaker::Lorem.words(rand(2..3)).join(' ').titleize }
    name_en { name_de + ' (en)' }

    after :build do |category|
      # Filters
      category.section_filters << (
        SectionFilter.first || FactoryGirl.create(:section_filter)
      )
    end
    trait :main do
      icon 'a-something'
    end
  end
end
