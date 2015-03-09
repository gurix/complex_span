require 'rails_helper'

describe RetrievalClicksController do
  describe 'GET index' do
    render_views

    let!(:session) { create :session }

    it 'returns a CSV with a header' do
      get :index, format: :csv

      csv = CSV.parse response.body,  converters: :numeric

      expect(csv.first).to eq %w(session_id trial word_position retrieval_position click_order clicked_at color delay text word_id size_difference
                                 retrieval_matrix_shown_at)

      click = session.trials.last.retrieval_clicks.last

      expect(csv.last).to eq [click.trials.sessions.id.to_s, click.trial, click.word_position, click.retrieval_position, click.click_order,
                              click.clicked_at.to_s, click.color, click.delay, click.text, click.word_id, click.size_difference,
                              click.trials.retrieval_matrix_shown_at.to_s]
    end
  end
end
