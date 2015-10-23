require "rails_helper"

RSpec.describe NewsletterMailer, type: :mailer do
  describe ".newsletter_email" do

    let(:user){FactoryGirl.create(:user, newsletter_subscriber: true)}
    let(:newsletter){FactoryGirl.create(:published_newsletter, emailed: false)}
    
    it "sends the email" do
      subscribed_user = user
      published_newsletter = newsletter
      
      expect(NewsletterMailer)
        .to receive(:send_newsletter_email)
        .with(user, newsletter)
        .and_return( double("NewsletterMailer", :deliver => true) )

      NewsletterMailer.send_newsletter_email(user, newsletter)
      
      mail = ApplicationMailer.deliveries.last
      expect(mail).not_to be_nil
      expect(mail.to).to eq('#{subscribed_user.email}')
    end

    it "has appropriate subject" do
      mail = NewsletterMailer.send_newsletter_email(user, newsletter)
      expect(mail).to have_subject('New at the Gallery')
    end

    it "sends from the default email" do
      mail = NewsletterMailer.send_newsletter_email(user, newsletter)
      expect(mail).to be_delivered_to(user.email)
    end

    it "HTML body has newsletter content" do
      mail = NewsletterMailer.send_newsletter_email(user, newsletter)
      expect(mail).to have_css('p','#{newsletter.content}')
    end
  end
end
