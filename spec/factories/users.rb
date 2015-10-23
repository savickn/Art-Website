FactoryGirl.define do
  factory :user do
    name "Example User"
    sequence(:email) { |n| "example-#{n}@railstutorial.org" }
    password "password"
    admin false
    newsletter_subscriber false
    created_at {Time.now}
  end
end
