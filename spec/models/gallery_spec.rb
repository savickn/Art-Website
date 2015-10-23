require 'rails_helper'

RSpec.describe Gallery, type: :model do
  describe "creation" do

    context "valid attributes" do
      it "should be valid" do
        gallery = FactoryGirl.build(:gallery)
        expect(gallery).to be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        gallery = FactoryGirl.build(:gallery, title: "")
        expect(gallery).not_to be_valid
      end
    end
    
    it "can create gallery with pictures" do 
      gallery = FactoryGirl.create(:gallery_with_pictures)
      expect(gallery).to be_valid
    end
  end

  describe "associations" do 
    it{is_expected.to have_many(:pictures)}
  end
    
  describe "validations" do
    it{is_expected.to validate_presence_of(:title)}
    it{is_expected.to validate_presence_of(:description)}
    #it{is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0)}
  end

end
