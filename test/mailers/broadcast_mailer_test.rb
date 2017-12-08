require_relative '../test_helper'

describe BroadcastMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:contact) { FactoryBot.create(:contact) }

  it 'must have a default from email address' do
    BroadcastMailer.default[:from].must_match(/.+@clarat\.org.*/)
  end
end
