module BaseTranslation
  # Enumerization
  extend Enumerize
  SOURCES = %w(researcher GoogleTranslate user).freeze
  enumerize :source, in: SOURCES

  MANUALLY_TRANSLATED_LOCALES = %w(ar ru).freeze

  def automated?
    source == 'GoogleTranslate'
  end

  # Was this translation manually edited by a human
  def manually_edited?
    MANUALLY_TRANSLATED_LOCALES.include?(locale) && !new_record? && !automated?
  end
end
