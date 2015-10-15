class Offer
  module Validations
    extend ActiveSupport::Concern

    included do
      validates :name, length: { maximum: 80 }, presence: true
      validates :name,
                uniqueness: { scope: :location_id },
                unless: ->(offer) { offer.location.nil? }
      validates :description, length: { maximum: 450 }, presence: true
      validates :next_steps, length: { maximum: 500 }, presence: true
      validates :opening_specification, length: { maximum: 400 }
      validates :legal_information, length: { maximum: 400 }
      validates :comment, length: { maximum: 800 }
      validates :slug, uniqueness: true
      validates :encounter, presence: true
      validates :expires_at, presence: true
      validates :expires_at, later_date: true, on: :create

      # Family section filtered validations
      validates :age_from,
                numericality: { greater_than_or_equal_to: 0, only_integer: true,
                                less_than_or_equal_to: 17, allow_blank: false },
                presence: true,
                if: :in_family_section?
      validates :age_to,
                numericality: { greater_than: 0, less_than_or_equal_to: 18,
                                only_integer: true, allow_blank: false },
                presence: true,
                if: :in_family_section?

      # Non-family section filtered validations
      validates :age_from,
                numericality: { greater_than_or_equal_to: 0, only_integer: true,
                                allow_blank: false },
                presence: true,
                unless: :in_family_section?
      validates :age_to,
                numericality: { greater_than: 0, only_integer: true,
                                allow_blank: false },
                presence: true,
                unless: :in_family_section?

      # Needs to be true before approval possible. Called in custom validation.
      # def before_approve
      #   TODO: Refactor age validations lead to simple HTML 5 checks which are
      #   eg not working in Safari. Also Rubocop complains...
      #   validate_associated_fields
      #   validate_target_audience
      # end

      private

      # Uses method from CustomValidatable concern.
      def validate_associated_fields
        validate_associated_presence :organizations
        validate_associated_presence :section_filters
        validate_associated_presence :language_filters
        validate_associated_presence :target_audience_filters
      end

      def validate_associated_presence field
        fail_validation field, "needs_#{field}" if send(field).empty?
      end

      def in_family_section?
        section_filters.to_a.any? { |filter| filter.identifier == 'family' }
      end
    end
  end
end
