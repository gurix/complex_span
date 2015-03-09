FactoryGirl.define do
  factory :log do
    message { Faker::Lorem.sentence }
    time { Time.now + rand(10).seconds }
  end
end
