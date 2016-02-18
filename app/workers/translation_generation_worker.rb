class TranslationGenerationWorker
  include Sidekiq::Worker

  def perform locale, object_type, object_id
    object = object_type.constantize.find(object_id)
    translation = find_or_initialize_translation(locale, object_type, object_id)

    translation.assign_attributes(
      generate_field_translations(object, locale)
    )
    translation.save!
    reindex object
  end

  private

  def find_or_initialize_translation locale, object_type, object_id
    translation_class = "#{object_type}Translation".constantize
    object_id_field = "#{object_type.downcase}_id"

    # return existing translation if one is found
    translation =
      translation_class.find_by locale: locale, object_id_field => object_id
    return translation if translation

    # otherwise create a new one
    translation_class.new(
      locale: locale,
      object_id_field => object_id
    )
  end

  def generate_field_translations object, locale
    translations_hash = direct_translate_to_html object, locale

    if locale == :de
      translations_hash['source'] = 'researcher'
    else
      translations_hash =
        GoogleTranslateCommunicator.get_translations translations_hash, locale
      translations_hash['source'] = 'GoogleTranslate'
    end

    translations_hash
  end

  def direct_translate_to_html object, locale
    translations_hash = {}

    object.translated_fields.each do |field|
      translations_hash[field] =
        direct_translate_via_strategy(object, field, locale)
    end

    translations_hash
  end

  def direct_translate_via_strategy object, field, locale = :de
    case field
    when :name
      object.untranslated_name
    when :description
      output = MarkdownRenderer.render(object.untranslated_description)
      output = Definition.infuse(output) if locale.to_sym == :de
      output
    when :old_next_steps, :opening_specification
      MarkdownRenderer.render object.send("untranslated_#{field}")
    else
      raise "TranslationGenerationWorker: #{field} needs translation strategy"
    end
  end

  def reindex object
    return unless object.is_a? Offer
    object.reload.algolia_index!
  end
end
