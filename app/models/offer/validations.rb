class Offer
  module Validations
    extend ActiveSupport::Concern

    included do
      validates :name, presence: true
      # TODO: replace with complicated custom validation OR save stamp text in model
      # validates :name,
      #           uniqueness: { scope: :location_id },
      #           unless: ->(offer) { offer.location.nil? }
      validates :description, presence: true
      validates :opening_specification, length: { maximum: 400 }
      validates :legal_information, length: { maximum: 400 }
      validates :slug, uniqueness: true
      validates :encounter, presence: true
      validates :expires_at, presence: true
      validates :expires_at, later_date: true
      validates :code_word, length: { maximum: 140 }

      MIN_AGE = 0
      MAX_AGE = 99
      # Age validation by section
      validates :age_from,
                numericality: { greater_than_or_equal_to: MIN_AGE,
                                only_integer: true,
                                less_than: MAX_AGE,
                                allow_blank: false },
                presence: true
      validates :age_to,
                numericality: { greater_than: MIN_AGE,
                                less_than_or_equal_to: MAX_AGE,
                                only_integer: true,
                                allow_blank: false },
                presence: true

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
        if in_family_section?
          validate_associated_presence :target_audience_filters
        end
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
