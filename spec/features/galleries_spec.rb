require 'rails_helper'

RSpec.feature "Galleries", type: :feature do
  let(:user){FactoryGirl.create(:user)}
  let(:admin_user){FactoryGirl.create(:user, admin: true)}
  let!(:gallery){FactoryGirl.create(:gallery_with_pictures)}
   
  feature "guest user (not logged in) interacting with gallery" do
    it "should redirect to login page when accessing :create" do 
      visit "/galleries/new"
      expect(current_path).to eq('/users/sign_in')
    end  
    
    it "should redirect to login page when accessing :edit" do 
      newgallery = gallery
      visit "/galleries/#{newgallery.id}/edit"
      expect(current_path).to eq('/users/sign_in')
    end
    
    it "can access :index" do 
      visit "/galleries"
      
      expect(page).to have_css('h1', 'Galleries')
      expect(current_path).to eq(galleries_path)
    end
    
    it "should show correct gallery when accessing :show" do 
      newgallery = gallery
      visit "/galleries/#{newgallery.id}"
      
      expect(current_path).to eq(gallery_path(newgallery.id))
      expect(page).to have_css('h1', 'Sheep')
      expect(page).to have_css('h2', 'Price: #{newgallery.price}')
    end
  end
  
  feature "non-admin user interacting with gallery" do
    before :each do 
      logged_as user
    end
     
    it "should redirect to home page when accessing :create" do 
      visit "/galleries/new"
      expect(current_path).to eq(root_path)
    end  
    
    it "should redirect to home page when accessing :edit" do 
      visit "/galleries/#{gallery.id}/edit"
      expect(current_path).to eq(root_path)
    end
  end
  
  feature "admin user interacting with forum" do 
    before :each do 
      logged_as admin_user
    end
    
    it "can create valid new gallery" do 
      visit "/galleries/new"
    
      fill_in "Title", :with => "Monet"
      fill_in "Description", :with => "A gallery of paintings by Monet"
      fill_in "Price", :with => 10
      attach_file('images[]', "spec/support/fixtures/vgfield.jpg")
      click_button "Create Gallery"
      
      expect(page).to have_title("Monet")
      expect(page).to have_css('p', 'A gallery of paintings by Monet')
      expect(page).to have_content("Gallery was successfully created.")
    end
    
    it "can update gallery" do
      newgallery = gallery 
      visit "/galleries/#{newgallery.id}/edit"
      
      expect(page).to have_css("h1", "Update the Gallery")
      
      fill_in "Title", :with => "Claude Monet"
      click_button "Update Gallery"
      
      expect(current_path).to eq(gallery_path(newgallery.id))
      expect(page).to have_content("Gallery updated")
      expect(page).to have_title("Claude Monet")
    end
    
    it "can delete gallery" do
      newgallery = gallery 
      visit "/galleries"
      click_link "Destroy"
      
      expect(current_path).to eq(galleries_path)
      expect(page).to have_content("Gallery was deleted")
      expect(page).not_to have_css("a", text: "Van Gogh")
    end
  end
end
