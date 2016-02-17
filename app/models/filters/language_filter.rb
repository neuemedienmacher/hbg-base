class LanguageFilter < Filter
  # Validations
  validates :identifier, length: { is: 3 }, presence: true, uniqueness: true
  # identifier: ISO 639-2 code

  # fixed sort (by importance)
  FIXED_IDENTIFIER = %w(deu ara eng fra pol rus tur 150)
  # sorted by german display name
  REMAINING_IDENTIFIER = %w(sqi amh aze ben bos bul zho 639 ell hin ita kik hrv
                            kur lav lit luo ltz mkd 568 nor fas por rom ron srp
                            snk spa swa swe tgk tam tel tha tuk 326 hun urd uzb
                            vie bel wol zza)
  IDENTIFIER = FIXED_IDENTIFIER + REMAINING_IDENTIFIER
  enumerize :identifier, in: LanguageFilter::IDENTIFIER
end
