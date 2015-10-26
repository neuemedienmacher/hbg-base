class LanguageFilter < Filter
  # Validations
  validates :identifier, length: { is: 3 }
  # identifier: ISO 639-2 code

  IDENTIFIER = %w(deu ara eng fra pol rus tur 150 326 568 639 amh aze ben bos
                  bul ell fas hin hrv hun ita kur lav lit mkd mul por rom ron
                  spa sqi srp tam tha urd vie wol
                )
  enumerize :identifier, in: LanguageFilter::IDENTIFIER
end
