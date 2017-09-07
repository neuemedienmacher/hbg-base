require_relative '../test_helper'

describe Tag do
  let(:tag) { Tag.new }

  subject { tag }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name_de }
    it { subject.must_respond_to :name_en }
    it { subject.must_respond_to :name_ar }
    it { subject.must_respond_to :name_tr }
    it { subject.must_respond_to :name_fr }
    it { subject.must_respond_to :name_pl }
    it { subject.must_respond_to :name_ru }
    it { subject.must_respond_to :name_fa }
    it { subject.must_respond_to :keywords_de }
    it { subject.must_respond_to :keywords_en }
    it { subject.must_respond_to :keywords_ar }
    it { subject.must_respond_to :keywords_fa }
    it { subject.must_respond_to :explanations_de }
    it { subject.must_respond_to :explanations_en }
    it { subject.must_respond_to :explanations_ar }
    it { subject.must_respond_to :explanations_fa }
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must have_many :tags_offers }
      it { subject.must have_many(:offers).through :tags_offers }
    end
  end
end
