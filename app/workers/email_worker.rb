class EmailWorker
  include Sidekiq::Worker
  #sidekiq_options queue: :high_priority, retry: 5, backtrace: true
  
  def perform(user_id, newsletter_id)
    user = User.find(user_id)
    newsletter = Newsletter.find(newsletter_id)
    
    if newsletter.emailed == false
      NewsletterMailer.send_newsletter_email(user, newsletter).deliver
      newsletter.emailed = true
      newsletter.save
    end
  end
end