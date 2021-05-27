class AddTokenToEmails < ActiveRecord::Migration[5.1]
  def change
    add_column :emails, :token, :string, limit: 64, default: nil
    # create unique token for every email that doesn't have one yet
    Email.where(token: nil).map do |email|
      initialize_token email
    end
  end

  def initialize_token email
    secure_token = loop do
      # creates a random hex string containing [a-z0-9] with length 64
      random_token = SecureRandom.hex(32)
      break random_token unless email.class.exists?(token: random_token)
    end
    # set secure (unique) token with update_columns
    email.update_columns token: secure_token
  end
end
