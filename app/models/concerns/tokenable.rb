module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :generate_token
  end

  protected

  def generate_token
    self.token = loop do
      # creates a random hex string containing [a-z0-9] with length 64
      random_token = SecureRandom.hex(32)
      break random_token unless self.class.exists?(token: random_token)
    end
  end
end
