# A unique email address
class Email < ActiveRecord::Base
  include AASM

  attr_accessor :given_security_code

  # Associations
  has_many :contact_people, inverse_of: :email
  has_many :offers, through: :contact_people, inverse_of: :emails
  has_many :organizations, through: :contact_people, inverse_of: :emails

  # Validations
  FORMAT = /\A.+@.+\..+\z/
  validates :address, uniqueness: true, presence: true, format: Email::FORMAT,
                      length: { minimum: 3, maximum: 64 }

  validates :security_code, presence: true, uniqueness: true, on: :update,
                            unless: :blocked?

  # State Machine
  aasm do
    state :uninformed, initial: true # E-Mail was created, owner doesn't know
    state :informed # An offer has been approved
    state :subscribed # Email recipient has subscribed to further updates
    state :unsubscribed # Email recipient was subscribed but is no longer
    state :blocked # Email is blocked from receiving mailings

    event :subscribe, guard: :security_code_confirmed? do
      transitions from: :informed, to: :subscribed
      transitions from: :unsubscribed, to: :subscribed
    end

    event :unsubscribe do
      transitions from: :subscribed, to: :unsubscribed
    end
  end

  # Methods

  def security_code_confirmed?
    given_security_code == security_code
  end

  private

  def regenerate_security_code
    self.security_code = SecureRandom.uuid
  end

  def should_be_blocked?
    contact_people.where(spoc: true).any?
  end
end
