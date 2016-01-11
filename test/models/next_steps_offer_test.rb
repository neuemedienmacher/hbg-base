require_relative '../test_helper'

describe NextStepsOffer do
  let(:next_steps_offer) { NextStepsOffer.new }
  subject { next_steps_offer }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :offer_id }
    it { subject.must_respond_to :next_step_id }
  end
end
