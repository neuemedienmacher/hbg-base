class LanguageFilter < Filter
  # Validations
  validates :identifier, length: { is: 3 }, presence: true, uniqueness: true
  # identifier: ISO 639-2 code (+ additional values)

  # fixed sort (by importance)
  FIXED_IDENTIFIER = %w(deu rom).freeze
  # sorted by german display name
  REMAINING_IDENTIFIER = %w(sqi amh aze ban ben ber bos bul zho 639 fin ell heb
                            hin ita kik kin kor hrv kur lav lit luo ltz mkd hbs
                            568 nor pus fas por rom ron srp skr som snk slo spa
                            swa swe tgk tgl tam tel tha cze tir tuk twi 326 hun
                            urd uzb vie bel wol zza mul).freeze
  IDENTIFIER = %w(sqi amh ara aze ban ben ber bos bul zho 639 deu 150 eng fin
                  fra ell heb hin ita kik kin kor hrv kur lav lit luo ltz mkd
                  hbs 568 nor pus fas pol por rom ron srp skr som snk slo spa
                  swa rus swe tgk tgl tam tel tha tir cze tur tuk twi 326 hun
                  urd uzb vie bel wol zza mul).freeze
  enumerize :identifier, in: LanguageFilter::IDENTIFIER
end
