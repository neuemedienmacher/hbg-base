FactoryGirl.define do
  factory :translation do
    locale 'de'
    source 'GoogleTranslate'
    offer

    factory :offer_translation, class: 'OfferTranslation' do
      name 'default offer_translation name'
      description 'default offer_translation description'
      next_steps 'default offer_translation next_steps'
    end

    factory :organization_translation do
      name 'default organization_translation name'
      description 'default organization_translation description'
    end

    factory :category_translation do
      name 'default category_translation name'
    end
  end
end
