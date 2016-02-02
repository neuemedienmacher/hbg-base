class LanguageFilter < Filter
  # Validations
  validates :identifier, length: { is: 3 }
  # identifier: ISO 639-2 code

  IDENTIFIER = %w(deu ara eng fra pol rus tur 150 sqi amh aze ban ben bos bul
                  zho 639 ell heb fin hat hin ita kik hrv kur lav lit luo ltz
                  mkd 568 nor fas por rom ron srp snk spa slo swa kor swe tgk
                  tam tel tha cze tuk 326 hun urd uzb vie bel wol zza)
  enumerize :identifier, in: LanguageFilter::IDENTIFIER
end
