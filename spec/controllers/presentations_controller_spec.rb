require 'rails_helper'

describe PresentationsController do
  describe 'GET index' do
    render_views

    let!(:session) { create :session }

    it 'returns a CSV with a header' do
      get :index, format: :csv

      csv = CSV.parse response.body,  converters: :numeric

      expect(csv.first).to eq %w(session_id trial word_position color delay start_time stop_time reaction_time pressed_key text word_id size_difference
                                 decision_missing judgment_correct trial_repeated)

      presentation = session.trials.last.words.last

      expect(csv.last).to eq [session.id.to_s, presentation.trial, presentation.word_position, presentation.color, presentation.delay,
                              exact_time(presentation.start_time), exact_time(presentation.stop_time), presentation.reaction_time, presentation.pressed_key,
                              presentation.text, presentation.word_id, presentation.size_difference, presentation.decision_missing.to_s,
                              presentation.judgment_correct.to_s, presentation.trials.repeated.to_s]
    end
  end
end
