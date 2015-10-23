FactoryGirl.define do
  factory :published_newsletter, class: Newsletter do
    title "First Newsletter"
    content "This is the first newsletter"
    published true
    emailed true
    created_at {Time.now}
  end

  factory :unpublished_newsletter, class: Newsletter do 
    title "Second Newsletter"
    content "This is the second newsletter"
    published false
    emailed false
    created_at {Time.now}
  end
end
