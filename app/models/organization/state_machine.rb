class Organization
  module StateMachine
    extend ActiveSupport::Concern

    included do
      include AASM
      aasm do
        ## States

        state :initialized, initial: true
        state :completed # organization information is complete
        state :approval_process # indicates the beginning of the approval process
        state :approved
        state :all_done # indicates that the organization with all its offers is done
        state :checkup_process # indicates the beginning of the checkup_process (after deactivation)

        # Special states object might enter before it is approved
        state :under_construction_pre, # Website under construction pre approve
              after_enter: :deactivate_offers_to_under_construction!,
              after_exit: :reinitialize_offers_from_under_construction!

        # Special states object might enter after it was approved
        state :internal_feedback, # There was an issue (internal)
              after_enter: :deactivate_offers!
        state :external_feedback, # There was an issue (external)
              after_enter: :deactivate_offers!
        state :under_construction_post, # Website under construction post approve
              after_enter: :deactivate_offers_to_under_construction!,
              after_exit: :reinitialize_offers_from_under_construction!

        ## Transitions

        event :reinitialize do
          transitions from: :under_construction_pre, to: :initialized
        end

        event :complete, success: :generate_translations! do
          transitions from: :initialized, to: :completed
          transitions from: :checkup_process, to: :completed
        end

        event :start_approval_process do
          # TODO: reactivate guard!!!
          transitions from: :completed, to: :approval_process # , guard: :different_actor?
        end

        event :approve, before: :set_approved_information do
          # TODO: reactivate guard!!!
          transitions from: :approval_process, to: :approved # , guard: :different_actor?
          transitions from: :checkup_process, to: :approved
        end

        event :approve_with_deactivated_offers,
              before: :set_approved_information,
              success: :reactivate_offers! do
          # TODO: reactivate guard!!!
          transitions from: :approval_process, to: :approved # , guard: :different_actor?
          transitions from: :checkup_process, to: :approved
        end

        event :deactivate_internal do
          transitions from: :approved, to: :internal_feedback
          transitions from: :all_done, to: :internal_feedback
          transitions from: :external_feedback, to: :internal_feedback
        end

        event :deactivate_external do
          transitions from: :approved, to: :external_feedback
          transitions from: :all_done, to: :external_feedback
          transitions from: :internal_feedback, to: :external_feedback
        end

        event :website_under_construction do
          # pre approve
          transitions from: :initialized, to: :under_construction_pre
          transitions from: :completed, to: :under_construction_pre
          # post approve
          transitions from: :approved, to: :under_construction_post
          transitions from: :all_done, to: :under_construction_post
          transitions from: :internal_feedback, to: :under_construction_post
          transitions from: :external_feedback, to: :under_construction_post
        end

        event :start_checkup_process do
          transitions from: :internal_feedback, to: :checkup_process
          transitions from: :external_feedback, to: :checkup_process
          transitions from: :under_construction_post, to: :checkup_process
          transitions from: :all_done, to: :checkup_process
          transitions from: :approved, to: :checkup_process
        end
      end

      # When an organization switches from approved to an unapproved state,
      # also deactivate all it's associated approved offers
      def deactivate_offers!
        offers.approved.find_each do |offer|
          next if offer.deactivate_through_organization!
          raise "#deactivate_offers! failed for #{offer.id}"
        end
      end

      # When an organization switches from an checkup/approval to approved,
      # also try to approve all it's associated organization_deactivated
      # and under_construction_post offers
      def reactivate_offers!
        offers.where(aasm_state: %w(organization_deactivated
                                    under_construction_post)).find_each do |o|
          # set to checkup and try to approve afterwards
          o.update_columns aasm_state: 'checkup_process'
          o.approve! if o.may_approve?
        end
      end

      # When an organization switches to a website_under_construction state, the
      # associated offers (in states: initialized, completed, approved or
      # organization_deactivated) also transitions to under_construction
      def deactivate_offers_to_under_construction!
        allowed_states = %w(initialized completed approved
                            organization_deactivated checkup_process)
        offers.where(aasm_state: allowed_states).find_each do |offer|
          next if offer.website_under_construction!
          raise "#deactivate_offer_to_under_construction failed for #{offer.id}"
        end
      end

      def reinitialize_offers_from_under_construction!
        offers.where(aasm_state: 'under_construction_pre')
              .find_each(&:reinitialize!)
      end
    end
  end
end
