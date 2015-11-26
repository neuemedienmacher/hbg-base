# After subscribing, push email to the newsletter provider (Mailchimp)
class EmailPusherWorker
  include Sidekiq::Worker

  def perform subscription_id
    logger.info Time.now
    logger.info Subscription.last.attributes
    subscription = Subscription.select(:id, :email).find(subscription_id)
    Gibbon::API.lists.subscribe(
      id: Rails.application.secrets.mailchimp['list_id'],
      email: { email: subscription.email },
      double_optin: true
    )
  end
end
