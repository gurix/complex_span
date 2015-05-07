class RetrievalClicksController < ApplicationController
  respond_to :html

  def index
    respond_to do |format|
      format.csv do
        configure_csv_response(filename: 'retrieval_clicks.csv')

        response.stream.write CSV.generate_line(csv_header)

        Session.each do | session |
          session.trials.each do | trial |
            trial.retrieval_clicks.each do | click |
              response.stream.write CSV.generate_line([session.id, click.trial, click.word_position, click.retrieval_position, click.click_order,
                                                       exact_time(click.clicked_at), click.color, click.delay, click.text, click.word_id, click.size_difference,
                                                       exact_time(trial.retrieval_matrix_shown_at), trial.repeated])
            end
          end
        end
        response.stream.close
      end
    end
  end

  def csv_header
    %w(session_id trial word_position retrieval_position click_order clicked_at color delay text word_id size_difference retrieval_matrix_shown_at
       trial_repeated)
  end
end
