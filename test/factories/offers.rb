require 'ffaker'

FactoryBot.define do
  factory :offer do
    # required fields
    name { FFaker::Lorem.words(rand(3..5)).join(' ').titleize }
    description { FFaker::Lorem.paragraph(rand(4..6))[0..399] }
    old_next_steps { FFaker::Lorem.paragraph(rand(1..3))[0..399] }
    encounter do
      # weighted
      %w[personal personal personal personal hotline chat
         forum email online-course portal].sample
    end
    area { Area.first unless encounter == 'personal' }
    approved_at nil

    # associations

    transient do
      website_count { rand(0..3) }
      language_count { rand(1..2) }
      audience_count 1
      opening_count { rand(1..5) }
      fake_address false
      section nil
      organizations nil
      divisions nil
    end

    after :build do |offer, evaluator|
      # SplitBase => Division(s) => Organization(s)
      organizations = evaluator.organizations ||
                      [FactoryBot.create(:organization, :approved)]
      organization = organizations.first
      div = organization.divisions.first ||
            FactoryBot.create(:division, organization: organization)
      offer.divisions << div

      # location
      if offer.personal?
        location =  organization.locations.sample ||
                    if evaluator.fake_address
                      FactoryBot.create(:location, :fake_address,
                                        organization: organization)
                    else
                      FactoryBot.create(:location, organization: organization)
                    end
        offer.location = location
      end
      # Filters
      offer.section = (
        Section.all.sample ||
          FactoryBot.create(:section)
      )

      evaluator.language_count.times do
        offer.language_filters << (
          LanguageFilter.all.sample ||
            FactoryBot.create(:language_filter)
        )
      end
    end

    after :create do |offer, evaluator|
      # Contact People
      offer.organizations.count.times do
        offer.contact_people << FactoryBot.create(
          :contact_person, organization: offer.organizations.first
        )
      end

      # ...
      create_list :hyperlink, evaluator.website_count, linkable: offer
      evaluator.opening_count.times do
        offer.openings << (
          if Opening.count != 0 && rand(2).zero?
            Opening.select(:id).all.sample
          else
            FactoryBot.create(:opening)
          end
        )
      end
      evaluator.audience_count.times do
        offer.target_audience_filters << (
          TargetAudienceFilter.all.sample ||
            FactoryBot.create(:target_audience_filter)
        )
      end
    end

    trait :approved do
      after :create do |offer, _evaluator|
        Offer.where(id: offer.id).update_all aasm_state: 'approved',
                                             approved_at: Time.zone.now
        offer.reload
      end
      approved_by { FactoryBot.create(:researcher).id }
    end

    trait :with_email do
      after :create do |offer, _evaluator|
        offer.contact_people.first.update_column(
          :email_id, FactoryBot.create(:email).id
        )
      end
    end

    trait :with_location do
      encounter 'personal'
    end

    trait :with_creator do
      created_by { FactoryBot.create(:researcher).id }
    end
  end
end

def maybe result
  rand(2).zero? ? nil : result
end
