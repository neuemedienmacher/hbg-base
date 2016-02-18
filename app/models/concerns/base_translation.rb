module BaseTranslation
  # Enumerization
  extend Enumerize
  SOURCES = %w(researcher GoogleTranslate user).freeze
  enumerize :source, in: SOURCES

  def automated?
    source == 'GoogleTranslate'
  end
end
