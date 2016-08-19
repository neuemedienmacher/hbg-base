require_relative '../test_helper'

describe Website do
  let(:website) do
    Website.new(host: 'own', url: 'http://www.clarat.org/example')
  end

  subject { website }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :host }
    it { subject.must_respond_to :url }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :unreachable_count }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :host }
      it { subject.must validate_presence_of :url }
      it { subject.must validate_uniqueness_of :url }
      it { subject.must validate_presence_of :unreachable_count }
    end
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must have_many :hyperlinks }
    end
  end

  describe 'Methods' do
    describe 'unreachable?' do
      it 'should return false for count < 2' do
        website.unreachable?.must_equal false
        website.unreachable_count = 1
        website.unreachable?.must_equal false
      end

      it 'should return true for count >= 2' do
        website.unreachable_count = 2
        website.unreachable?.must_equal true
        website.unreachable_count = 42
        website.unreachable?.must_equal true
      end
    end
  end
end
