require 'ffaker'

FactoryGirl.define do
  factory :category do
    name { FFaker::Lorem.words(rand(2..3)).join(' ').titleize }

    trait :main do
      icon 'a-something'
    end

    after :build do |category|
      # Filters
      category.section_filters << (
        SectionFilter.all.sample ||
          FactoryGirl.create(:section_filter)
      )
    end
  end
end
