require_relative '../test_helper'

describe Assignment do
  let(:assignment) { Assignment.new }
  subject { assignment }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :assignable }
    it { subject.must_respond_to :creator }
    it { subject.must_respond_to :creator_team }
    it { subject.must_respond_to :receiver }
    it { subject.must_respond_to :receiver_team }
    it { subject.must_respond_to :parent }
    it { subject.must_respond_to :children }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :topic }
    it { subject.must_respond_to :created_by_system }
  end

  describe 'Scopes' do
    before do
      FactoryGirl.create :organization
      @assignment = Assignment.where(assignable_type: 'Organization').last
    end
    describe 'active' do
      it 'responds correctly to opened scope' do
        Assignment.where(assignable_type: 'Organization').active.count.must_equal 1
        @assignment.update_column :aasm_state, 'closed'
        Assignment.where(assignable_type: 'Organization').active.count.must_equal 0
      end
    end
    describe 'closed' do
      it 'responds correctly to closed scope' do
        Assignment.where(assignable_type: 'Organization').closed.count.must_equal 0
        @assignment.update_column :aasm_state, 'closed'
        Assignment.where(assignable_type: 'Organization').closed.count.must_equal 1
      end
    end
    describe 'base' do
      it 'responds correctly to base scope' do
        Assignment.where(assignable_type: 'Organization').base.count.must_equal 1
        @assignment.update_column :assignable_field_type, 'SomeField'
        Assignment.where(assignable_type: 'Organization').base.count.must_equal 0
      end
    end
    describe 'field' do
      it 'responds correctly to field scope' do
        Assignment.where(assignable_type: 'Organization').field.count.must_equal 0
        @assignment.update_column :assignable_field_type, 'SomeField'
        Assignment.where(assignable_type: 'Organization').field.count.must_equal 1
      end
    end

    describe 'User' do
      before do
        @assignment = Assignment.new(id: 1, assignable_type: 'OrganizationTranslation',
        assignable_id: 1)
      end

      it 'nullifies creator id when user gets deleted' do
        user = users(:researcher)
        @assignment.creator_id = user.id
        user.destroy
        @assignment.reload.creator_id.must_equal nil
      end

      it 'nullifies receiver id when user gets deleted' do
        user = users(:researcher)
        @assignment.receiver_id = user.id
        user.destroy
        @assignment.reload.receiver_id.must_equal nil
      end
    end
  end
end
