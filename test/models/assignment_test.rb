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
      @assignments = Assignment.where(assignable_type: 'Organization')
    end
    describe 'active' do
      it 'responds correctly to opened scope' do
        @assignments.active.count.must_equal 1
        @assignments.last.update_column :aasm_state, 'closed'
        @assignments.active.count.must_equal 0
      end
    end
    describe 'closed' do
      it 'responds correctly to closed scope' do
        @assignments.closed.count.must_equal 0
        @assignments.last.update_column :aasm_state, 'closed'
        @assignments.closed.count.must_equal 1
      end
    end
    describe 'base' do
      it 'responds correctly to base scope' do
        @assignments.base.count.must_equal 1
        @assignments.last.update_column :assignable_field_type, 'SomeField'
        @assignments.base.count.must_equal 0
      end
    end
    describe 'field' do
      it 'responds correctly to field scope' do
        @assignments.field.count.must_equal 0
        @assignments.last.update_column :assignable_field_type, 'SomeField'
        @assignments.field.count.must_equal 1
      end
    end

    describe 'User' do
      before do
        @assignment = Assignment.new(id: 1,
                                     assignable_type: 'OrganizationTranslation',
                                     assignable_id: 1)
        @user = users(:researcher)
      end

      it 'nullifies creator id when user gets deleted' do
        @assignment.creator_id = @user.id
        @user.destroy
        @assignment.reload.creator_id.must_equal nil
      end

      it 'nullifies receiver id when user gets deleted' do
        @assignment.receiver_id = @user.id
        @user.destroy
        @assignment.reload.receiver_id.must_equal nil
      end
    end
  end
end
