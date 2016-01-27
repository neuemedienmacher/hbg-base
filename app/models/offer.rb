# One of the main models. The offers that visitors want to find.
# Has modules in offer subfolder.
class Offer < ActiveRecord::Base
  has_paper_trail

  # Modules
  include Validations, CustomValidations, Associations, Search, StateMachine

  # Concerns
  include Creator, CustomValidatable, Notable

  # Enumerization
  extend Enumerize
  ENCOUNTERS = %w(personal hotline email chat forum online-course portal)
  EXCLUSIVE_GENDERS = %w(boys_only girls_only) # nil = inclusive to any gender
  TREATMENT_TYPES = %w(in-patient semi-residential out-patient)
  PARTICIPANT_STRUCTURES = %w(target_audience_alone target_audience_and_others)
  BENEFICIARY_GENDERS = %w(female male) # nil = inclusive to any gender
  enumerize :encounter, in: ENCOUNTERS
  enumerize :exclusive_gender, in: EXCLUSIVE_GENDERS
  enumerize :gender_first_part_of_stamp, in: BENEFICIARY_GENDERS
  enumerize :gender_second_part_of_stamp, in: BENEFICIARY_GENDERS
  enumerize :treatment_type, in: TREATMENT_TYPES
  enumerize :participant_structure, in: PARTICIPANT_STRUCTURES
  CONTACT_TYPES = %w(personal remote)

  # Friendly ID
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged]

  def slug_candidates
    [
      :name,
      [:name, :location_zip]
    ]
  end

  # Scopes
  scope :approved, -> { where(aasm_state: 'approved') }
  scope :created_at_day, ->(date) { where('created_at::date = ?', date) }
  scope :approved_at_day, ->(date) { where('approved_at::date = ?', date) }
  scope :in_section, lambda { |section|
    joins(:section_filters).where(filters: { identifier: section })
  }

  # Methods

  delegate :name, :street, :addition, :city, :zip, :address,
           to: :location, prefix: true, allow_nil: true

  delegate :minlat, :maxlat, :minlong, :maxlong,
           to: :area, prefix: true, allow_nil: true

  # handled in observer before save
  def generate_html!
    self.description_html = MarkdownRenderer.render description
    self.description_html = Definition.infuse description_html
    self.next_steps_html = MarkdownRenderer.render next_steps
    if opening_specification
      self.opening_specification_html =
        MarkdownRenderer.render opening_specification
    end
    true
  end

  def opening_details?
    !openings.blank? || !opening_specification.blank?
  end

  def organization_display_name
    if organizations.count > 1
      I18n.t 'offer.organization_display_name.cooperation'
    elsif organizations.any?
      organizations.first.name
    end
  end

  def in_section? section
    section_filters.where(identifier: section).count > 0
  end
end
