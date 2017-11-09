require_relative '../test_helper'

describe Assignable do
  let(:assignment) do
    FactoryGirl.create :assignment
  end
  subject { assignment.assignable }

  describe 'basics' do
    it 'should respond to assignments' do
      subject.assignments.count.must_equal 1
      subject.assignments.first.must_equal assignment
    end

    it 'must destroy associated assignments when assignable is destroyed' do
      subject.assignments.count.must_equal 1
      subject.assignments.first.close!
      new_assignment = Assignment.create!(
        assignable: subject, assignable_type: subject.class.name,
        creator_id: 1, creator_team_id: 1, receiver_id: 2,
        receiver_team_id: 2, message: 'TestMessage'
      )
      subject.assignments.count.must_equal 2
      # check if data is persisted
      subject.persisted?.must_equal true
      assignment.persisted?.must_equal true
      new_assignment.persisted?.must_equal true
      # destroy offer => destroys all translations => destroys all assignments
      subject.offer.destroy!
      # record lookups fail => everything is destroyed
      assert_raises(ActiveRecord::RecordNotFound) { subject.reload }
      assert_raises(ActiveRecord::RecordNotFound) { assignment.reload }
      assert_raises(ActiveRecord::RecordNotFound) { new_assignment.reload }
    end
  end

  describe 'current_assignment' do
    it 'finds the newest active base association without a parent' do
      model = Organization.first
      Assignment.create(
        assignable: model, aasm_state: 'open', message: 'earlier decoy'
      )
      correct_assignment = Assignment.create(
        assignable: model, aasm_state: 'open', message: 'correct'
      )
      Assignment.create(
        assignable: model, aasm_state: 'closed', message: 'closed decoy'
      )
      Assignment.create(
        assignable: model, aasm_state: 'open', assignable_field_type: 'name',
        message: 'non-base decoy'
      )
      Assignment.create(
        assignable: model, aasm_state: 'open', parent: correct_assignment,
        message: 'child decoy'
      )
      Assignment.create(
        assignable: Division.first, aasm_state: 'open',
        message: 'other assignable decoy'
      )
      model.reload.current_assignment.must_equal correct_assignment
    end

    it 'should be able to eager_load' do
      assignment = Assignment.create!(
        assignable_type: 'Division', assignable_id: Division.first.id,
        message: 'whatever', topic: 'new', receiver_id: User.first.id,
        creator_id: User.first.id
      )
      result = Division.eager_load(:current_assignment)
                       .where('assignments.id = ?', assignment.id).first
      result.class.must_equal Division
      result.current_assignment.must_equal assignment
    end
  end
end
