class ProductivityGoal < ActiveRecord::Base
  # Associations
  belongs_to :team, inverse_of: :productivity_goals

  # Enumerization
  extend Enumerize
  TARGET_MODELS = %w(Offer Organization SplitBase).freeze
  TARGET_FIELD_NAMES = %w(aasm_state version).freeze
  enumerize :target_model, in: TARGET_MODELS
  enumerize :target_field_name, in: TARGET_FIELD_NAMES
end
