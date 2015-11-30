module Translation
  extend ActiveSupport::Concern

  included do
    # rubocop:disable Style/MethodLength
    # because this is essentially many separate small methods
    def self.translate *fields
      fields.each do |field|
        # :name -> translated #name getter
        define_method field do
          if translation && !translation.send(field).blank?
            translation.send(field)
          else
            send("untranslated_#{field}")
          end
        end

        # :name -> #untranslated_name as regular #name getter
        define_method "untranslated_#{field}" do
          attributes[field.to_s]
        end

        # simple getter for all fields that are translated for this object
        define_method :translated_fields do
          fields
        end
      end
    end
    # rubocop:enable Style/MethodLength

    has_many :translations, class_name: "#{self.name}Translation",
                            inverse_of: self.name.downcase

    def translation_automated?
      return false unless translation
      translation.automated?
    end

    def translation
      @_translation ||= translations.find_by(locale: I18n.locale)
    end

    # cache key always needs locale
    def cache_key
      super + I18n.locale.to_s
    end
  end
end
