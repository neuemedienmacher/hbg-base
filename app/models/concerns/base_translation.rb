module BaseTranslation
  # Enumerization
  extend Enumerize
  SOURCES = %w[researcher GoogleTranslate user].freeze
  enumerize :source, in: SOURCES

  MANUALLY_TRANSLATED_LOCALES =
    (I18n.available_locales - [:de]).map(&:to_s).freeze

  def automated?
    source == 'GoogleTranslate'
  end

  # Is this translation editable by a human?
  def manually_editable?
    MANUALLY_TRANSLATED_LOCALES.include?(locale)
  end

  # Was this translation manually edited by a human
  def manually_edited?
    manually_editable? && !new_record? && !automated?
  end
end
