# Hierarchical categorier to sort offers.
class Category < ActiveRecord::Base
  # AwesomeNestedSet
  # acts_as_nested_set counter_cache: :children_count, depth_column: :depth
  has_closure_tree

  # Concerns
  include CustomValidatable

  # associtations
  has_and_belongs_to_many :offers
  has_and_belongs_to_many :section_filters,
                          association_foreign_key: 'filter_id'
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

  # Scope
  scope :mains, -> { where.not(icon: nil).order(:icon).limit(5) }

  # Methods

  # alias for rails_admin_nestable
  singleton_class.send :alias_method, :arrange, :hash_tree

  # cached hash_tree, prepared for use in offers#index
  def self.sorted_hash_tree section_filter_ident = 'family'
    # find every category that is not in the current world
    # TODO: do this different (with fancy search query)?!
    world_filter = SectionFilter.find_by identifier: section_filter_ident
    invalid_categories = []
    Category.all.find_each do |category|
      invalid_categories << category unless
                            category.section_filters.include? world_filter
    end

    Rails.cache.fetch "sorted_hash_tree_#{section_filter_ident}" do
      current_tree = hash_tree
      # remove all invalid (without current world filter) categories
      invalid_categories.each do |invalid_category|
        current_tree = current_tree.deep_reject_key!(invalid_category)
      end
      current_tree.sort_by { |tree| tree.first.icon || '' }
    end
  end

  # display name: each category gets suffixes for each worlds and
  # main categories get an additional asterisk
  def name_with_world_suffix_and_optional_asterisk
    worlds_suffix = '('
    section_filters.map { |filter| worlds_suffix += filter.name.first }
    worlds_suffix += ')'
    name + (icon ? "#{worlds_suffix}*" : worlds_suffix) if name
  end

  # custom validation methods
  def validate_section_filter_presence
    fail_validation(:section_filters, 'needs_section_filters') if
      send(:section_filters).empty?
  end

  def validate_section_filters_with_parent
    if parent_id
      section_filters.each do |filter|
        parent = Category.find(parent_id)
        fail_validation(:section_filters,
                        'parent_needs_same_section_filter',
                        parent_name: parent.name,
                        filter_name: filter.name) unless
                        parent.section_filters.pluck(:id).include? filter.id
      end
    end
  end
end
