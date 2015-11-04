require_relative '../test_helper'

describe Subscription do
  let(:subscription) { Subscription.new email: 'a@b.c' }

  it 'must be valid' do
    subscription.must_be :valid?
  end

  describe 'Observer' do
    it 'should call email pusher worker on create' do
      EmailPusherWorker.expects(:perform_async).with(1)
      Subscription.create email: 'a@b.c'
    end
  end
end
