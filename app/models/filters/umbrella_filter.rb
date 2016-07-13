# Multiple umbrella selection
class UmbrellaFilter < Filter
  IDENTIFIER = %w(caritas diakonie awo dpw drk asb zwst dbs vdw bags svdkd bkd
                  church hospital public other).freeze
  enumerize :identifier, in: UmbrellaFilter::IDENTIFIER
end
