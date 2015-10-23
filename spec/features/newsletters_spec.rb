require 'rails_helper'

RSpec.feature "Newsletters", type: :feature do
  let(:user){FactoryGirl.create(:user)}
  let(:admin_user){FactoryGirl.create(:user, admin: true)}
  let(:published_newsletter){FactoryGirl.create(:published_newsletter)}
  let(:unpublished_newsletter){FactoryGirl.create(:unpublished_newsletter)}
   
  feature "guest user (not logged in) interacting with newsletter" do
    it "should redirect to login page when accessing :create" do 
      visit "/newsletters/new"
      expect(current_path).to eq('/users/sign_in')
    end  
    
    it "should redirect to login page when accessing :edit" do 
      new_newsletter = published_newsletter
      visit "/newsletters/#{new_newsletter.id}/edit"
      expect(current_path).to eq('/users/sign_in')
    end
    
    it "should redirect to login page when accessing :index" do 
      visit "/newsletters"
      expect(current_path).to eq('/users/sign_in')
    end
    
    it "should redirect to login page when accessing :show" do 
      new_newsletter = published_newsletter
      visit "/newsletters/#{new_newsletter.id}"
      expect(current_path).to eq('/users/sign_in')
    end
  end
  
  feature "non-admin user interacting with newsletter" do
    before :each do 
      logged_as user
    end
     
    it "should redirect to login page when accessing :create" do 
      visit "/newsletters/new"
      expect(current_path).to eq(root_path)
    end  
    
    it "should redirect to login page when accessing :edit" do 
      new_newsletter = published_newsletter
      visit "/newsletters/#{new_newsletter.id}/edit"
      expect(current_path).to eq(root_path)
    end
    
    context "accessing :index" do
      it "is accessible" do
        visit "/newsletters"
        expect(page).to have_css('h1', 'Newsletter Archive')
      end
      
      it "cannot view create newsletters link" do
        visit "/newsletters"
        expect(page).to have_css('h1', 'Newsletter Archive')
        expect(page).not_to have_css('h2 a', 'Create Newsletter')
      end
      
      it "can view published newsletters" do
        new_newsletter1 = published_newsletter
        visit "/newsletters"
        expect(page).to have_css('a', 'First Newsletter}')
      end

      it "cannot view unpublished newsletters" do
        new_newsletter2 = unpublished_newsletter
        visit "/newsletters"
        expect(page).to have_css('h1', 'Newsletter Archive')
        expect(page).not_to have_css('h2 a', 'Second Newsletter')
      end      
    end
    
    context "accessing :show" do
      it "can view published newsletters" do 
        new_newsletter1 = published_newsletter
        visit "/newsletters/#{new_newsletter1.id}"
        
        expect(current_path).to eq(newsletter_path(new_newsletter1.id))
        expect(page).to have_css('h1', 'First Newsletter')
        expect(page).to have_css('p', 'This is the first newsletter')
      end
      
      it "should redirect to root when viewing unpublished newsletters" do
        new_newsletter2 = unpublished_newsletter
        visit "/newsletters/#{new_newsletter2.id}"
        expect(current_path).to eq(newsletters_path)
      end
    end
  end
  
  feature "admin user interacting with newsletter" do 
    before :each do 
      logged_as admin_user
    end
    
    context "creating new newsletter" do
      it "can create valid new newsletter" do 
        visit "/newsletters/new"
        create_newsletter "Third Newsletter", "This is the third newsletter"
        
        expect(page).to have_title("Third Newsletter")
        expect(page).to have_css('p', 'This is the third newsletter')
        expect(page).to have_content("Newsletter was successfully created.")
      end
      
      it "published newsletters will be enqueued via EmailWorker" do
        new_user = FactoryGirl.create(:user, newsletter_subscriber: true)
        
        expect(EmailWorker).not_to have_enqueued_job
        
        visit "/newsletters/new"
        create_newsletter "Third Newsletter", "This is the third newsletter"
        published_newsletter = Newsletter.last
        
        expect(EmailWorker).to have_enqueued_job(new_user.id, published_newsletter.id)
        expect(NewsletterMailer).to receive(:send_newsletter_email)
        .with(new_user, published_newsletter)
        .and_return( double("NewsletterMailer", :deliver => true) )
      end
    end
    
    it "can update newsletter" do
      new_newsletter = published_newsletter
      visit "/newsletters/#{new_newsletter.id}/edit"
      
      expect(page).to have_css("h1", "Edit Newsletter")
      
      fill_in "Title", :with => "Fourth Newsletter"
      click_button "Update Newsletter"
      
      expect(current_path).to eq(newsletter_path(new_newsletter.id))
      expect(page).to have_content("Newsletter updated")
      expect(page).to have_title("Fourth Newsletter")
    end
    
    it "can delete newsletter" do
      new_newsletter = published_newsletter
      visit "/newsletters"
      click_link "Delete"
      
      expect(current_path).to eq(newsletters_path)
      expect(page).to have_content("Newsletter was deleted")
      expect(page).not_to have_css("a", text: "First Newsletter")
    end
  end
  
  private

  def create_newsletter(title, content)
    fill_in "Title", :with => title
    fill_in "Content", :with => content
    check "Publish this newsletter?"
    click_button "Create Newsletter"
  end
end
