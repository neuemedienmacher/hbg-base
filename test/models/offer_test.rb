require_relative '../test_helper'

describe Offer do
  let(:offer) { Offer.new }
  let(:basicOffer) { offers(:basic) }

  subject { offer }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :description }
    it { subject.must_respond_to :next_steps }
    it { subject.must_respond_to :slug }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :opening_specification }
    it { subject.must_respond_to :aasm_state }
    it { subject.must_respond_to :legal_information }
    it { subject.must_respond_to :age_from }
    it { subject.must_respond_to :age_to }
    it { subject.must_respond_to :exclusive_gender }
    it { subject.must_respond_to :target_audience }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :name }
      it { subject.must validate_presence_of :description }
      it { subject.must validate_presence_of :next_steps }
      it { subject.must validate_presence_of :encounter }
      it { subject.must validate_length_of(:legal_information).is_at_most 400 }
      it { subject.must validate_presence_of :expires_at }
      it do
        subject.must validate_length_of(:opening_specification).is_at_most 400
      end

      it 'should ensure that age_from fits age_to' do
        basicOffer.age_from = 9
        basicOffer.age_to = 1
        basicOffer.wont_be :valid?
        basicOffer.age_to = 10
        basicOffer.must_be :valid?
      end

      it 'should ensure a personal offer has a location' do
        basicOffer.encounter = 'personal'
        basicOffer.location_id = nil
        basicOffer.wont_be :valid?
        basicOffer.location_id = 1
        basicOffer.must_be :valid?
      end

      it 'should ensure a remote offer has no location but an area' do
        basicOffer.encounter = 'hotline'
        basicOffer.location_id = 1
        basicOffer.area_id = 1
        basicOffer.wont_be :valid?
        basicOffer.location_id = 1
        basicOffer.area_id = nil
        basicOffer.wont_be :valid?
        basicOffer.location_id = nil
        basicOffer.area_id = nil
        basicOffer.wont_be :valid?

        basicOffer.location_id = nil
        basicOffer.area_id = 1
        basicOffer.must_be :valid? # !
      end

      it 'should ensure locations and organizations fit together (personal)' do
        location = FactoryGirl.create(:location)
        basicOffer.location_id = location.id
        basicOffer.wont_be :valid?
        location.update_column :organization_id, organizations(:basic).id
        basicOffer.location.reload
        basicOffer.must_be :valid?
      end

      it 'should ensure all chosen organizations are approved' do
        basicOffer.organizations.update_all aasm_state: 'expired'
        basicOffer.reload.wont_be :valid?
        basicOffer.organizations.update_all aasm_state: 'approved'
        basicOffer.reload.must_be :valid?
      end

      it 'should ensure chosen contact people are SPoC or belong to orga' do
        cp = FactoryGirl.create :contact_person, spoc: false,
                                                 offers: [basicOffer]
        basicOffer.reload.wont_be :valid?
        cp.update_column :spoc, true
        basicOffer.reload.must_be :valid?
        cp.update_columns spoc: false, organization_id: organizations(:basic).id
        basicOffer.reload.must_be :valid?
      end

      # it 'should ensure chosen contact people belong to a chosen orga' do
      #   basicOffer.reload.wont_be :valid?
      #   basicOffer.reload.must_be :valid?
      # end
    end

    describe 'when in family section' do
      before { subject.section_filters = [filters(:family)] }

      it do
        subject.must validate_numericality_of(:age_from).only_integer
          .is_greater_than_or_equal_to(0).is_less_than_or_equal_to(17)
      end
      it do
        subject.must validate_numericality_of(:age_to).only_integer
          .is_greater_than(0).is_less_than_or_equal_to(17)
      end
    end

    describe 'when not in family section' do
      before { subject.section_filters = [] }

      it do
        subject.must validate_numericality_of(:age_from).only_integer
          .is_greater_than_or_equal_to(0) # no less_than_or_equal_to
      end
      it do
        subject.must validate_numericality_of(:age_to).only_integer
          .is_greater_than(0) # no less_than_or_equal_to
      end
    end

    describe 'custom' do
      it 'should validate expiration date' do
        subject.expires_at = Time.zone.now
        subject.valid?
        subject.errors.messages[:expires_at].must_include(
          I18n.t('shared.validations.later_date')
        )
      end
    end
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must belong_to :location }
      it { subject.must have_many :organization_offers }
      it { subject.must have_many(:organizations).through :organization_offers }
      it { subject.must have_and_belong_to_many :categories }
      it { subject.must have_and_belong_to_many :filters }
      it { subject.must have_and_belong_to_many :section_filters }
      it { subject.must have_and_belong_to_many :language_filters }
      it { subject.must have_and_belong_to_many :target_audience_filters }
      it { subject.must have_and_belong_to_many :openings }
      it { subject.must have_many :hyperlinks }
      it { subject.must have_many :websites }
    end
  end

  describe 'methods' do
    describe '#creator' do
      it 'should return anonymous by default' do
        offer.creator.must_equal 'anonymous'
      end

      it 'should return users name if there is a version' do
        offer = FactoryGirl.create :offer, :with_creator
        offer.creator.must_equal User.find(offer.created_by).name
      end
    end

    describe '#_tags' do
      it 'should return unique categories with ancestors of an offer' do
        offers(:basic).categories << categories(:sub1)
        offers(:basic).categories << categories(:sub2)
        tags = offers(:basic)._tags
        tags.must_include 'sub1.1'
        tags.must_include 'sub1.2'
        tags.must_include 'main1'
        tags.count('main1').must_equal 1
        tags.wont_include 'main2'
      end
    end

    describe '#organization_display_name' do
      it "should return the first organization's name if there is only one" do
        offers(:basic).organization_display_name.must_equal(
          organizations(:basic).name
        )
      end

      it 'should return a string when there are multiple organizations' do
        offers(:basic).organizations << FactoryGirl.create(:organization)
        offers(:basic).organization_display_name.must_equal(
          I18n.t('offer.organization_display_name.cooperation')
        )
      end
    end

    describe '#personal_indexable?' do
      it 'should return true when personal and approved' do
        offer.aasm_state = 'approved'
        offer.stubs(:personal?).returns true
        offer.personal_indexable?.must_equal true
      end

      it 'should return false when not personal and approved' do
        offer.aasm_state = 'approved'
        offer.stubs(:personal?).returns false
        offer.personal_indexable?.must_equal false
      end

      it 'should return false when not approved' do
        offer.aasm_state = 'completed'
        offer.expects(:personal?).never
        offer.personal_indexable?.must_equal false
      end
    end

    describe '#remote_indexable?' do
      it 'should return true when not personal and approved' do
        offer.aasm_state = 'approved'
        offer.stubs(:personal?).returns false
        offer.remote_indexable?.must_equal true
      end

      it 'should return false when personal and approved' do
        offer.aasm_state = 'approved'
        offer.stubs(:personal?).returns true
        offer.remote_indexable?.must_equal false
      end

      it 'should return false when not approved' do
        offer.aasm_state = 'completed'
        offer.expects(:personal?).never
        offer.remote_indexable?.must_equal false
      end
    end

    describe '#target_audience_filters?' do
      it 'should behave correctly in family section' do
        offer = offers(:basic)
        offer.section_filters = [filters(:family)]
        offer.expects(:fail_validation).never
        offer.send :validate_associated_fields
        offer.target_audience_filters = []
        offer.expects(:fail_validation).with :target_audience_filters,
                                             'needs_target_audience_filters'
        offer.send :validate_associated_fields
      end

      it 'should behave correctly in refugees section' do
        offer = offers(:basic)
        offer.section_filters = [filters(:refugees)]
        offer.expects(:fail_validation).never
        offer.send :validate_associated_fields
        offer.target_audience_filters = []
        offer.send :validate_associated_fields
      end
    end

    describe '#section_filters_must_match_categories_section_filters' do
      it 'should fail when single filter does not match' do
        offer = offers(:basic)
        category = categories(:main1)
        offer.section_filters << filters(:refugees)
        offer.categories << category
        offer.expects(:fail_validation).with(
          :section_filters, 'section_filter_not_found_in_category',
          world: 'Refugees', category: category.name
        )
        offer.section_filters_must_match_categories_section_filters
      end

      it 'should fail when multiple filters do not match' do
        off = offers(:basic)
        category = categories(:main2)
        off.section_filters = [filters(:refugees), filters(:family)]
        off.categories << category
        off.expects(:fail_validation).with(
          :section_filters, 'section_filter_not_found_in_category',
          world: 'Family', category: category.name
        )
        off.section_filters_must_match_categories_section_filters
      end

      it 'should fail only on mismatching categories' do
        off = offers(:basic)
        category = categories(:main2)
        off.section_filters = [filters(:refugees), filters(:family)]
        off.categories << category
        off.categories << categories(:main3)
        off.expects(:fail_validation).with(
          :section_filters, 'section_filter_not_found_in_category',
          world: 'Family', category: category.name
        )
        off.section_filters_must_match_categories_section_filters
      end

      it 'should succeed when single family world matches' do
        off = offers(:basic)
        off.section_filters = [filters(:family)]
        off.categories << categories(:main1)
        off.expects(:fail_validation).never
        off.section_filters_must_match_categories_section_filters
      end

      it 'should succeed when single refugee world matches on multiple' do
        off = offers(:basic)
        off.section_filters = [filters(:refugees)]
        off.categories << categories(:main3)
        off.expects(:fail_validation).never
        off.section_filters_must_match_categories_section_filters
      end

      it 'should succeed when multiple worlds match' do
        off = offers(:basic)
        off.section_filters = [filters(:refugees), filters(:family)]
        off.categories << categories(:main3)
        off.expects(:fail_validation).never
        off.section_filters_must_match_categories_section_filters
      end
    end

    describe '::per_env_index' do
      it 'should return Offer_envname for a non-development env' do
        Offer.per_env_index.must_equal 'Offer_test'
      end

      it 'should attach the user name to the development env' do
        Rails.stubs(:env)
          .returns ActiveSupport::StringInquirer.new('development')
        ENV.stubs(:[]).returns 'foobar'
        Offer.per_env_index.must_equal 'Offer_development_foobar'
      end
    end

    describe 'Algolia overwrites: ::reindex' do
      it 'should call the algolia original multiple times' do
        Offer.expects(:algolia_reindex).times(I18n.available_locales.length)
        Offer.reindex
      end

      it 'should run without errors' do
        Offer.reindex
      end
    end

    describe 'translation' do
      it 'should get translated name, description, and next_steps' do
        Offer.any_instance.stubs(:generate_translations!)
        offer = FactoryGirl.create :offer
        offer.translations <<
          FactoryGirl.create(:offer_translation, locale: :de, name: 'de name',
                                                 description: 'de desc',
                                                 next_steps: 'de next')
        offer.translations <<
          FactoryGirl.create(:offer_translation, locale: :en, name: 'en name',
                                                 description: 'en desc',
                                                 next_steps: 'en next')
        old_locale = I18n.locale

        I18n.locale = :de
        offer.name.must_equal 'de name'
        offer.description.must_equal 'de desc'
        offer.next_steps.must_equal 'de next'

        I18n.locale = :en
        offer = Offer.find(offer.id) # clear memoization
        offer.name.must_equal 'en name'
        offer.description.must_equal 'en desc'
        offer.next_steps.must_equal 'en next'

        I18n.locale = old_locale
      end
    end

    describe 'State Machine' do
      describe '#different_actor?' do
        it 'should return true when created_by differs from current_actor' do
          offer.created_by = 99
          offer.send(:different_actor?).must_equal true
        end

        it 'should return false when created_by is the same as current_actor' do
          offer.created_by = offer.current_actor
          offer.send(:different_actor?).must_equal false
        end

        it 'should return falsy when created_by is nil' do
          offer.send(:different_actor?).must_equal nil
        end

        it 'should return false when current_actor is nil' do
          offer.created_by = 1
          offer.stubs(:current_actor).returns(nil)
          offer.send(:different_actor?).must_equal nil
        end
      end
    end

    describe '#opening_details?' do
      it 'should return false when there are no openings / opening specs' do
        offer.opening_details?.must_equal false
      end

      it 'should return true when there are openings and opening specs' do
        offer.openings = Opening.limit(1)
        offer.opening_specification = 'chunky bacon'
        offer.opening_details?.must_equal true
      end
    end

    describe 'search' do
      it 'should correctly return geolocation hash for algolia' do
        loc = FactoryGirl.create(:location)
        basicOffer.location_id = loc.id
        basicOffer._geoloc.must_equal('lat' => 10, 'lng' => 20)
      end

      it 'should correctly return keywords_string' do
        basicOffer.keywords << keywords(:basic)
        basicOffer.keyword_string.must_equal 'test, synonym'
      end

      it 'should correctly return age_filters' do
        basicOffer._age_filters.must_equal((0..17).to_a)
      end

      it 'should correctly return organization_names' do
        basicOffer.organization_names.must_equal 'foobar'
      end

      it 'should correctly return _exclusive_gender_filters' do
        basicOffer.exclusive_gender = 'boys_only'
        basicOffer._exclusive_gender_filters.must_equal(['boys_only'])
      end

      it 'should correctly return target_audience_filters' do
        basicOffer._target_audience_filters.must_equal(['children'])
      end

      it 'should correctly return language_filters' do
        basicOffer._language_filters.must_equal(['deu'])
      end
    end
  end
end
