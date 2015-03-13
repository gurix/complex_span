require 'rails_helper'

describe PresentationsController do
  describe 'GET index' do
    render_views

    let!(:session) { create :session }

    it 'returns a CSV with a header' do
      get :index, format: :csv

      csv = CSV.parse response.body,  converters: :numeric

      expect(csv.first).to eq %w(session_id trial word_position color delay start_time stop_time reaction_time pressed_key text word_id size_difference)

      presentation = session.trials.last.words.last

      expect(csv.last).to eq [session.id.to_s, presentation.trial, presentation.word_position, presentation.color, presentation.delay,
                              exact_time(presentation.start_time), exact_time(presentation.stop_time), presentation.reaction_time, presentation.pressed_key,
                              presentation.text, presentation.word_id, presentation.size_difference]
    end
  end
end
