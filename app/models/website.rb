# The external web addresses of organizations and offers.

class Website < ActiveRecord::Base
  # associtations
  has_many :hyperlinks, dependent: :destroy
  has_many :organizations, through: :hyperlinks,
                           source: :linkable, source_type: 'Organization'
  has_many :offers, through: :hyperlinks,
                    source: :linkable, source_type: 'Offer'

  # Enumerization
  extend Enumerize
  HOSTS = %w(own facebook twitter youtube gplus pinterest document
             online_consulting chat forum online_course application_form
             contact_form other).freeze
  enumerize :host, in: HOSTS

  # Validations
  validates :host, presence: true
  validates :url, format: %r{\Ahttps?://\S+\.\S+\z}, uniqueness: true,
                  presence: true

  # Scopes..
  # .. by hostname
  HOSTS.each { |host_name| scope host_name, -> { where(host: host_name) } }
  # .. by url
  scope :pdf, -> { where('websites.url LIKE ?', '%.pdf') }
  scope :non_pdf, -> { where.not('websites.url LIKE ?', '%.pdf') }

  def shorten_url
    URI.parse(self.url).host
  end
end
