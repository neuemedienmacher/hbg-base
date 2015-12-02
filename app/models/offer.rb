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
  ENCOUNTERS = %w(personal hotline email chat forum online-course)
  EXCLUSIVE_GENDERS = %w(boys_only girls_only) # nil = inclusive to any gender
  enumerize :encounter, in: ENCOUNTERS
  enumerize :exclusive_gender, in: EXCLUSIVE_GENDERS
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

  # Customize duplication.
  # Lots of configs here, so we are OK with a longer method:
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def partial_dup
    self.dup.tap do |offer|
      offer.comment = ''
      offer.renewed = false
      offer.created_by = nil
      offer.location = self.location
      offer.organizations = self.organizations
      offer.openings = self.openings
      offer.categories = self.categories
      offer.section_filters = self.section_filters
      offer.language_filters = self.language_filters
      offer.target_audience_filters = self.target_audience_filters
      offer.websites = self.websites
      offer.contact_people = self.contact_people
      offer.keywords = self.keywords
      offer.area = self.area
      offer.aasm_state = 'initialized'
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

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

  # Get an array of websites, ordered as follows: (1) own non-pdf (2) own pdf
  # (3+) remaining HOSTS in order, except "other"
  def structured_websites
    # TODO: Refactor!
    sites = [
      websites.own.non_pdf.first,
      websites.own.pdf.first
    ]
    Website::HOSTS[1..-2].each do |host| # no "other"
      sites << websites.send(host).first
    end
    sites.compact
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

  def gmaps_info
    {
      title: name,
      address: location_address,
      organization_display_name: organization_display_name
    }
  end

  def in_section? section
    section_filters.where(identifier: section).count > 0
  end
end
