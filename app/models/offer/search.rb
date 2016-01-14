class Offer
  module Search
    extend ActiveSupport::Concern

    included do
      include AlgoliaSearch

      def self.per_env_index
        if Rails.env.development?
          "Offer_development_#{ENV['USER']}"
        else
          "Offer_#{Rails.env}"
        end
      end

      def self.personal_index_name locale
        "#{per_env_index}_personal_#{locale}"
      end

      def self.remote_index_name locale
        "#{per_env_index}_remote_#{locale}"
      end

      algoliasearch do
        I18n.available_locales.each do |locale|
          I18n.with_locale(locale) do
            index = %w(
              name description next_steps_concat keyword_string organization_names
            )
            # :category_string,
            attributes = [:organization_display_name, :location_address] + index
            facets = [:_tags, :_age_filters, :_language_filters,
                      :_section_filters, :_target_audience_filters,
                      :_exclusive_gender_filters]

            add_index Offer.personal_index_name(locale),
                      disable_indexing: Rails.env.test?,
                      if: :personal_indexable? do
              attributesToIndex index
              ranking %w(
                typo geo words proximity attribute exact custom
              )
              add_attribute(*attributes)
              add_attribute(*facets)
              add_attribute :_geoloc
              attributesForFaceting facets
              optionalWords STOPWORDS
            end

            add_index Offer.remote_index_name(locale),
                      disable_indexing: Rails.env.test?,
                      if: :remote_indexable? do
              attributesToIndex index
              add_attribute(*attributes)
              add_attribute :area_minlat, :area_maxlat, :area_minlong,
                            :area_maxlong
              remote_facets = facets + [:encounter]
              add_attribute(*remote_facets)
              attributesForFaceting remote_facets
              optionalWords STOPWORDS

              # no geo necessary
              ranking %w(typo words proximity attribute exact custom)
            end
          end
        end
      end

      def personal_indexable?
        approved? && personal?
      end

      def remote_indexable?
        approved? && !personal?
      end

      def personal?
        encounter == 'personal'
      end

      # Offer's location's geo coordinates for indexing
      def _geoloc
        {
          'lat' => location.try(:latitude) || '0.0',
          'lng' => location.try(:longitude) || '0.0'
        }
      end

      # Offer's categories for indexing
      def _tags
        tags = []
        categories.find_each do |category|
          tags << category.self_and_ancestors.pluck(:name)
        end
        tags.flatten.uniq
      end

      # additional searchable string made from categories
      # TODO: Ueberhaupt notwendig, wenn es fuer Kategorien keine Synonyme mehr
      # gibt?
      # "category_string_#{locale}",
      # def category_string
      #   categories.pluck(:name).flatten.compact.uniq.join(', ')
      # end

      # additional searchable string made from categories
      def keyword_string
        keywords.pluck(:name, :synonyms).flatten.compact.uniq.join(', ')
      end

      # concatenated organization name for search index
      def organization_names
        organizations.pluck(:name).join(', ')
      end

      def next_steps_concat
        next_steps.pluck("text_#{I18n.locale}").join(' ')
      end

      # filter indexing methods
      %w(target_audience language section).each do |filter|
        define_method "_#{filter}_filters" do
          send("#{filter}_filters").pluck(:identifier)
        end
      end

      def _age_filters
        (age_from..age_to).to_a
      end

      def _exclusive_gender_filters
        [exclusive_gender]
      end

      ### Overwrite Algolia methods to fit our localization logic ###

      # def self.reindex
      #   I18n.available_locales.each do |locale|
      #     I18n.with_locale(locale) do
      #       algolia_reindex
      #     end
      #   end
      # end
      # singleton_class.send(:alias_method, :reindex!, :reindex)
      #
      # def index!(locale = nil)
      #   if locale
      #     I18n.with_locale(locale) { algolia_index! }
      #   else
      #     I18n.available_locales.each { |al| index!(al) } # recursion!
      #   end
      # end
    end
  end
end
