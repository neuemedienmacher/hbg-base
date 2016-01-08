class LanguageFilter < Filter
  # Validations
  validates :identifier, length: { is: 3 }
  # identifier: ISO 639-2 code

  IDENTIFIER = %w(deu ara eng fra pol rus tur 150 sqi amh aze ben bos bul 639
                  ell hin ita hrv kik kur lav lit mkd 568 fas por rom ron spa
                  srp tam tha 326 hun urd vie wol)
  enumerize :identifier, in: LanguageFilter::IDENTIFIER
end
