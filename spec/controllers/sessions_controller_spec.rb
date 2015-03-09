require 'rails_helper'

describe SessionsController do
  describe 'GET index' do
    render_views

    let!(:session) { create :session }

    it 'returns a CSV with a header' do
      get :index, format: :csv

      csv = CSV.parse response.body,  converters: :numeric

      expect(csv.first).to eq %w(id age sincerity gender education ip_address number_of_logs number_of_trials sys_screen_width sys_screen_height
                                 sys_navigator_user_agent sys_navigator_platform sys_window_innerHeight sys_window_innerWidth sys_window_screenX
                                 sys_window_screenY sys_window_pageXOffset sys_window_pageYOffset)

      expect(csv.last).to eq [session.id.to_s, session.age, session.sincerity, session.gender, session.education, session.ip_address, session.language,
                              session.logs.count, session.trials.count] + session.system_information.values
    end
  end
end
