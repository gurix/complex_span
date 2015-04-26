FactoryGirl.define do
  factory :word do
    color { %w(red blue).sample }
    text { Faker::Lorem.word }
    delay { [200, 1500].sample }
    size_difference { rand(9999) }
    trial { rand(14) }
    word_position { rand(10) }
    word_id { rand(250) }
    start_time { Time.now + rand(60).seconds }
    stop_time { |word| word.start_time + rand(60).seconds }
    reaction_time { |word| word.stop_time - word.start_time }
    pressed_key { [39, 37].sample }
    decision_missing { false }
    judgment_correct { true }
  end
end
