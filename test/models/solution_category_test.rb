require_relative '../test_helper'

describe SolutionCategory do
  let(:category) { SolutionCategory.new }

  subject { category }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :parent_id }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :name }
    end
  end

  describe 'associations' do
    it { subject.must have_many(:offers) }
  end
end
