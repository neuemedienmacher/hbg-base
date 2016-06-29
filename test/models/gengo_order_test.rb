require_relative '../test_helper'

describe GengoOrder do
  let(:gengo_order) { GengoOrder.new }
  subject { gengo_order }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :order_id }
    it { subject.must_respond_to :expected_slug }
  end

  describe 'validations' do
    it { subject.must validate_presence_of :order_id }
    it { subject.must validate_uniqueness_of :order_id }
    it { subject.must validate_presence_of :expected_slug }
  end
end
