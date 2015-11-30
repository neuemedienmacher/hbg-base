# Hierarchical categories to sort offers.
class Category < ActiveRecord::Base
  # AwesomeNestedSet
  # acts_as_nested_set counter_cache: :children_count, depth_column: :depth
  has_closure_tree

  # Concerns
  include CustomValidatable, Translation

  # associtations
  has_and_belongs_to_many :section_filters,
                          association_foreign_key: 'filter_id'
  has_many :categories_offers
  has_many :offers, through: :categories_offers
  has_many :organizations, through: :offers
  # To order with closure_tree
  has_closure_tree order: 'sort_order'

  # Validations
  validates :name, uniqueness: true, presence: true

  # Custom Validations
  validate :validate_section_filter_presence
  validate :validate_section_filters_with_parent

  # Sanitization
  extend Sanitization
  auto_sanitize :name

  # Translation
  translate :name

  # Scope
  scope :mains, -> { where.not(icon: nil).order(:icon).limit(6) }
  scope :in_section, lambda { |section|
    joins(:section_filters).where(filters: { identifier: section })
  }

  # Methods

  # alias for rails_admin_nestable
  singleton_class.send :alias_method, :arrange, :hash_tree

  # display name: each category gets suffixes for each section and
  # main categories get an additional asterisk
  def name_with_world_suffix_and_optional_asterisk
    return unless name
    sections_suffix = "(#{section_filters.map { |f| f.name.first }.join(',')})"
    name + (icon ? "#{sections_suffix}*" : sections_suffix)
  end

  # custom validation methods
  def validate_section_filter_presence
    return unless send(:section_filters).empty?
    fail_validation(:section_filters, 'needs_section_filters')
  end

  def validate_section_filters_with_parent
    if parent_id
      section_filters.each do |filter|
        parent = Category.find(parent_id)
        next if parent.section_filters.pluck(:id).include? filter.id
        fail_validation(:section_filters,
                        'parent_needs_same_section_filter',
                        parent_name: parent.name,
                        filter_name: filter.name)
      end
    end
  end
end
