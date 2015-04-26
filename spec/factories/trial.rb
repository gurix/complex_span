FactoryGirl.define do
  factory :trial do
    word_delay { [200, 1500].sample }
    retrieval_matrix_shown_at { Time.now + rand(60).seconds }
    started_at { Time.now + rand(60).seconds }
    correct_judgments { 7 }
    repeated { false }

    after :build do |trial, _evaluator|
      trial.words << build_list(:word, 10)
      trial.retrievals << build_list(:retrieval, 15)
      trial.retrieval_clicks << build_list(:retrieval_click, 5)
    end
  end
end
