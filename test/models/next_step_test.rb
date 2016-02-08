require_relative '../test_helper'

describe NextStep do
  let(:next_step) { NextStep.new }
  subject { next_step }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it 'must have a text_* for every available locale' do
      I18n.available_locales.each do |locale|
        subject.must_respond_to "text_#{locale}"
      end
    end
  end

  describe 'validations' do
    it { subject.must validate_presence_of :text_de }
    it { subject.must validate_length_of(:text_de).is_at_most 255 }
    it { subject.must validate_length_of(:text_en).is_at_most 255 }
    it { subject.must validate_length_of(:text_ar).is_at_most 255 }
    it { subject.must validate_length_of(:text_fr).is_at_most 255 }
    it { subject.must validate_length_of(:text_tr).is_at_most 255 }
    it { subject.must validate_length_of(:text_pl).is_at_most 255 }
    it { subject.must validate_length_of(:text_ru).is_at_most 255 }
  end
end
