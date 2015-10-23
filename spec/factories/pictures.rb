FactoryGirl.define do
  factory :picture do 
    association :gallery, :factory => :gallery_with_pictures
    image { File.new("#{Rails.root}/spec/support/fixtures/vgcity.jpg") } 
    default_image 0
    created_at {Time.now}
  end
  
  factory :picture1, class: Picture do
    association :gallery, factory: :gallery_with_pictures
    image { File.new("#{Rails.root}/spec/support/fixtures/vgtrees.jpg") }
    default_image 1 
    created_at {Time.now}
  end
  
  factory :picture2, class: Picture do
    association :gallery, factory: :gallery_with_pictures
    image { File.new("#{Rails.root}/spec/support/fixtures/vgfield.jpg") }
    default_image 0 
    created_at {Time.now}
  end
  
end
