module BaseTranslation
  # Enumerization
  extend Enumerize
  SOURCES = %w(researcher GoogleTranslate user)
  enumerize :source, in: SOURCES

  def automated?
    source == 'GoogleTranslate'
  end
end
