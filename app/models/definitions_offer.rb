# Connector model
class DefinitionsOffer < ApplicationRecord
  belongs_to :offer
  belongs_to :definition
end
