FactoryGirl.define do
  factory :retrieval_click do
    color { %w(red blue).sample }
    text { Faker::Lorem.word }
    delay { [200, 1500].sample }
    size_difference { rand(9999) }
    trial { rand(14) }
    word_position { rand(10) }
    word_id { rand(250) }
    retrieval_position { rand(15) }

    clicked_at { Time.now + rand(10).seconds }
    click_order { rand(15) }
  end
end
