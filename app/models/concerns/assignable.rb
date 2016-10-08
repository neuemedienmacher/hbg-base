module Assignable
  extend ActiveSupport::Concern

  included do
    # Associations
    has_many :assignments, as: :assignable, inverse_of: :assignable
    accepts_nested_attributes_for :assignments

    # Methods
    def field_assignments
      self.assignments.field
    end

    def current_assignment
      self.assignments.active.root.base.first
    end

    def current_field_assignment field
      # return nil if the required field is not existing on the Assignable model
      return nil unless self.respond_to?(field)
      # return open field assignment if one exists or current model assignment
      assignments.active.root.where(assignable_field_type: field).first ||
        current_assignment
    end

    def assign_new_user_team! creator_id, creator_team_id, reciever_team_id, message = ''
      create_new_assignment!(creator_id, creator_team_id, nil, reciever_team_id, message)
    end

    # closes the current assignment and creates a new one
    def create_new_assignment! creator_id, creator_team_id, reciever_id, reciever_team_id, message = ''
      current_assignment.close!
      Assignment.create!(
        assignable: self,
        assignable_type: self.class.name,
        creator_id: creator_id,
        creator_team_id: creator_team_id,
        reciever_id: reciever_id,
        reciever_team_id: reciever_team_id,
        message: message
      )
    end

    # TODO: Restrictions (e.g. may_assign?, can_assign?)
    # TODO: Sub-Assignments ()
  end
end
