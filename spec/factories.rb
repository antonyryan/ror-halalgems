FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "User #{n}" }
    sequence(:email) { |n| "user_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    license_no "123456"

    factory :admin do
      admin true
    end
  end

  factory :bed do
    sequence(:name)  { |n| "bed #{n}" }
  end
  factory :listing_type do
    sequence(:name)  { |n| "type #{n}" }
  end
  factory :property_type do
    sequence(:name)  { |n| "type #{n}" }
  end

  factory :status do
    sequence(:name)  { |n| "status #{n}" }
  end
  factory :neighborhood do
    sequence(:name)  { |n| "neighbor #{n}" }
  end

  factory :listing do
    neighborhood
    status
    listing_type
    property_type
    street_address 'Some address'
    available_date {Date::tomorrow}
    landlord 'some name'
    user
    bed
  end   
end