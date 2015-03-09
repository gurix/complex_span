require 'rails_helper'

describe RetrievalsController do
  describe 'GET index' do
    render_views

    let!(:session) { create :session }

    it 'returns a CSV with a header' do
      get :index, format: :csv

      csv = CSV.parse response.body,  converters: :numeric

      expect(csv.first).to eq %w(session_id trial word_position retrieval_position color delay text word_id size_difference retrieval_matrix_shown_at)

      retrieval = session.trials.last.retrievals.last

      expect(csv.last).to eq [retrieval.trials.sessions.id.to_s, retrieval.trial, retrieval.word_position, retrieval.retrieval_position, retrieval.color,
                              retrieval.delay, retrieval.text, retrieval.word_id, retrieval.size_difference, retrieval.trials.retrieval_matrix_shown_at.to_s]
    end
  end
end
