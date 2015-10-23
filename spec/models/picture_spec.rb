require 'rails_helper'

RSpec.describe Picture, type: :model do
  describe "validations" do 
    it {is_expected.to validate_presence_of :image}
    it {is_expected.to validate_presence_of :gallery_id}
  end
  
  describe "associations" do
    it {is_expected.to belong_to :gallery}
  end
end
