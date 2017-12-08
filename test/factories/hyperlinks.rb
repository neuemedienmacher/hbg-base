FactoryBot.define do
  factory :hyperlink do
    linkable { FactoryBot.create %i[offer location organization].sample }
    website
  end
end
