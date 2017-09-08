require_relative '../test_helper'

describe Topic do
  let(:topic) { Topic.new }

  subject { topic }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must have_many :topics_organizations }
      it { subject.must have_many(:organizations).through :topics_organizations }
    end
  end
end
