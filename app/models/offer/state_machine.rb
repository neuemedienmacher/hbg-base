class Offer
  module StateMachine
    extend ActiveSupport::Concern

    included do
      include AASM
      aasm do
        ## States

        # Normal Workflow
        state :initialized, initial: true
        state :completed
        state :approval_process # indicates the beginning of the approval process
        state :approved
        state :checkup # indicates the beginning of the checkup process (after deactivation)

        # Special states object might enter before it is approved
        state :dozing # For uncompleted offers that we want to track
        state :under_construction_pre # Website under construction pre approve

        # Special states object might enter after it was approved
        state :paused # I.e. Seasonal offer is in off-season
        state :expired # Happens automatically after a pre-set amount of time
        state :internal_feedback # There was an issue (internal)
        state :external_feedback # There was an issue (external)
        state :organization_deactivated # An associated orga was deactivated
        state :under_construction_post # Website under construction post approve
        state :seasonal_pending # seasonal offer is reviewed but out of TimeFrame
        state :website_unreachable # crawler could not reach website twice in a row

        ## Transitions

        event :reinitialize do
          transitions from: :dozing, to: :initialized
          transitions from: :under_construction_pre, to: :initialized
        end

        event :doze do
          transitions from: :initialized, to: :dozing
          transitions from: :checkup, to: :dozing
        end

        event :complete, before: :set_completed_information,
                         success: :generate_translations! do
          transitions from: :initialized, to: :completed
          transitions from: :checkup, to: :completed
        end

        event :start_approval_process do
          # TODO: guard this as well or only this?
          transitions from: :completed, to: :approval_process # , guard: :different_actor?
        end

        event :approve, before: :set_approved_information do
          transitions from: :approval_process, to: :seasonal_pending,
                      guard: :seasonal_offer_not_yet_to_be_approved?
          transitions from: :seasonal_pending, to: :approved,
                      guard: :seasonal_offer_ready_for_approve?
          # TODO: reactivate guard!!!
          transitions from: :approval_process, to: :approved # , guard: :different_actor?
          transitions from: :organization_deactivated, to: :approved,
                      guard: :all_organizations_approved?
        end

        # TODO: remove some transitions for these four states?

        event :pause do
          # only first transition? (automatically instead of expire for seasonal_offers)
          transitions from: :approved, to: :paused
          transitions from: :expired, to: :paused
          transitions from: :internal_feedback, to: :paused
          transitions from: :external_feedback, to: :paused
        end

        event :expire do
          transitions from: :approved, to: :expired
          transitions from: :paused, to: :expired
          transitions from: :internal_feedback, to: :expired
          transitions from: :external_feedback, to: :expired
        end

        event :deactivate_internal do
          transitions from: :approved, to: :internal_feedback
          transitions from: :paused, to: :internal_feedback
          transitions from: :expired, to: :internal_feedback
          transitions from: :external_feedback, to: :internal_feedback
        end

        event :deactivate_external do
          transitions from: :approved, to: :external_feedback
          transitions from: :paused, to: :external_feedback
          transitions from: :expired, to: :external_feedback
          transitions from: :internal_feedback, to: :external_feedback
        end

        event :deactivate_through_organization do
          transitions from: :approved, to: :organization_deactivated,
                      guard: :at_least_one_organization_not_approved?
        end

        event :website_under_construction do
          # pre approve
          transitions from: :initialized, to: :under_construction_pre
          transitions from: :completed, to: :under_construction_pre
          # post approve
          transitions from: :approved, to: :under_construction_post
          transitions from: :paused, to: :under_construction_post
          transitions from: :expired, to: :under_construction_post
          transitions from: :internal_feedback, to: :under_construction_post
          transitions from: :external_feedback, to: :under_construction_post
          transitions from: :organization_deactivated, to: :under_construction_post
        end

        event :website_twice_unreachable do
          transitions from: :approved, to: :website_unreachable
        end

        event :start_checkup_process do
          transitions from: :paused, to: :checkup
          transitions from: :expired, to: :checkup
          transitions from: :internal_feedback, to: :checkup
          transitions from: :external_feedback, to: :checkup
          transitions from: :under_construction_post, to: :checkup
          transitions from: :website_unreachable, to: :checkup
          transitions from: :organization_deactivated, to: :checkup # manual reactivation
        end
      end

      private

      def at_least_one_organization_not_approved?
        organizations.where.not(aasm_state: 'approved').any?
      end

      def all_organizations_approved?
        !at_least_one_organization_not_approved?
      end

      def set_approved_information
        self.approved_at = Time.zone.now
        self.approved_by = current_actor
        # update to current LogicVersion
        self.logic_version_id = LogicVersion.last.id
      end

      def set_completed_information
        # update to current LogicVersion
        self.logic_version_id = LogicVersion.last.id
      end

      def different_actor?
        created_by && current_actor && created_by != current_actor
      end

      # TODO
      def seasonal_offer_not_yet_to_be_approved?
        false # self.starts_at && self.starts_at > Time.zone.now # && different_actor?
      end

      # TODO
      def seasonal_offer_ready_for_approve?
        false # self.starts_at && self.starts_at <= Time.zone.now # && different_actor?
      end
    end
  end
end
