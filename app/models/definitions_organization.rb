# Connector model
class DefinitionsOrganization < ApplicationRecord
  belongs_to :organization
  belongs_to :definition
end
