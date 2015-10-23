FactoryGirl.define do
  factory :gallery do
    title "Van Gogh"
    description "A collection of paintings by Van Gogh"
    price 10
    created_at {Time.now}
  end
  
  factory :gallery_with_pictures, class: Gallery, :parent => :gallery do 
    after(:create) do |gallery|
      gallery.pictures << FactoryGirl.create(:picture1, :gallery => gallery)
      gallery.pictures << FactoryGirl.create(:picture2, :gallery => gallery)
    end
  end
  
end
