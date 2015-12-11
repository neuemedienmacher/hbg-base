require_relative '../test_helper'

class GeolocationTest < ActiveSupport::TestCase # to have fixtures
  let(:geolocation) { Geolocation.new }

  describe '#to_h' do
    it 'should return the lat and long in a hash' do
      geoloc = Geolocation.new OpenStruct.new(latitude: 1, longitude: 2)
      geoloc.to_h.must_equal latitude: 1, longitude: 2
    end
  end
end
