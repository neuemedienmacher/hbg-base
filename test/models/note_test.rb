require_relative '../test_helper'

describe Note do
  let(:note) { Note.new }
  subject { note }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :text }
    it { subject.must_respond_to :topic }
    it { subject.must_respond_to :user }
    it { subject.must_respond_to :notable }
    it { subject.must_respond_to :referencable }
  end

  describe 'Scope' do
    describe 'not_referencing_note' do
      it 'finds notes with a referencable_type other than Note' do
        Note.not_referencing_note.count.must_equal 0
        note = FactoryGirl.create :note
        Note.not_referencing_note.count.must_equal 1
        note.update_column :referencable_type, 'Note'
        Note.not_referencing_note.count.must_equal 0
      end
    end
  end
end
