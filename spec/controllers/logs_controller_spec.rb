require 'rails_helper'

describe LogsController do
  describe 'GET index' do
    render_views

    let!(:session) { create :session }

    it 'returns a CSV with a header' do
      get :index, format: :csv

      csv = CSV.parse response.body,  converters: :numeric

      expect(csv.first).to eq %w(session_id message time)

      log = session.logs.last

      expect(csv.last).to eq [log.sessions.id.to_s, log.message, log.time.to_s]
    end
  end
end
