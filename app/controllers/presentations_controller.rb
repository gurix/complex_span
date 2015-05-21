class PresentationsController < ApplicationController
  include ActionController::Live
  respond_to :csv

  def index
    configure_csv_response(filename: 'presentations.csv')

    response.stream.write CSV.generate_line(csv_header)

    Session.each do |session|
      session.trials.each do |trial|
        trial.words.each do |presentation|
          response.stream.write CSV.generate_line([session.id, presentation.trial, presentation.word_position, presentation.color, presentation.delay,
                                                   exact_time(presentation.start_time), exact_time(presentation.stop_time), presentation.reaction_time,
                                                   presentation.pressed_key, presentation.text, presentation.word_id, presentation.size_difference,
                                                   presentation.decision_missing,  presentation.judgment_correct, trial.repeated])
        end
      end
    end
    response.stream.close
  end

  def csv_header
    %w(session_id trial word_position color delay start_time stop_time reaction_time pressed_key text word_id size_difference decision_missing
       judgment_correct trial_repeated)
  end
end
