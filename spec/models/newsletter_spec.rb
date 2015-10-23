require 'rails_helper'

RSpec.describe Newsletter, type: :model do
  describe "creation" do

    context "valid attributes" do
      it "should be valid" do
        newsletter = FactoryGirl.build(:published_newsletter)
        expect(newsletter).to be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        newsletter = FactoryGirl.build(:published_newsletter, title: "")
        expect(newsletter).not_to be_valid
      end
    end
  end
  
  describe "validations" do 
    it{is_expected.to validate_presence_of(:title)}
    it{is_expected.to validate_presence_of(:content)}
    it{is_expected.to validate_length_of(:content).is_at_least(10)}
  end
  
  describe ".publish_recent_newsletters" do
    it "should call EmailWorker" do
      published_newsletter = FactoryGirl.create(:published_newsletter, emailed: false)
      subscribed_user = FactoryGirl.create(:user, newsletter_subscriber: true)
      
      #expect(EmailWorker).to have_enqueued_job(subscribed_user.id, published_newsletter.id)
      expect(EmailWorker).to receive(:perform_async).with(subscribed_user.id, published_newsletter.id)
      Newsletter.publish_recent_newsletters
    end
  end
end
