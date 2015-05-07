class RetrievalsController < ApplicationController
  respond_to :html

  def index
    respond_to do |format|
      format.csv do
        configure_csv_response(filename: 'retrievals.csv')

        response.stream.write CSV.generate_line(csv_header)

        Session.each do | session |
          session.trials.each do | trial |
            trial.retrievals.each do | retrieval |
              response.stream.write CSV.generate_line([session.id, retrieval.trial, retrieval.word_position, retrieval.retrieval_position,
                                                       retrieval.color, retrieval.delay, retrieval.text, retrieval.word_id, retrieval.size_difference,
                                                       exact_time(trial.retrieval_matrix_shown_at), trial.repeated])
            end
          end
        end
        response.stream.close
      end
    end
  end

  def csv_header
    %w(session_id trial word_position retrieval_position color delay text word_id size_difference retrieval_matrix_shown_at trial_repeated)
  end
end
