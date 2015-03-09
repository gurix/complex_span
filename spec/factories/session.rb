FactoryGirl.define do
  factory :session do
    age 42
    sincerity 'test'
    gender 'f'
    education 'high_shool'
    system_information do
      {
        screen_width: 1920,
        screen_height: 1200,
        navigator_user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.115 Safari/537.36',
        navigator_platform: 'MacIntel',
        window_innerHeight: 1057,
        window_innerWidth: 927,
        window_screenX: 22,
        window_screenY: 45,
        window_pageXOffset: 0,
        window_pageYOffset: 0
      }
    end
    language 'en'
    ip_address '127.0.0.1'

    after :build do |session, _evaluator|
      session.trials << build_list(:trial, 14)
      session.logs << build_list(:log, 2)
    end
  end
end
