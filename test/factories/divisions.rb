# frozen_string_literal: true

FactoryBot.define do
  factory :division do
    addition 'default division addition'
    section { Section.all.sample }
    city { City.all.sample }
    organization { FactoryBot.create(:organization, :approved) }

    after :create do |division, _evaluator|
      division.assignments <<
        FactoryBot.create(
          :assignment,
          assignable_type: 'Division',
          assignable_id: division.id
        )
    end
  end
end
