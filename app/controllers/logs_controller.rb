class LogsController < ApplicationController
  include ActionController::Live
  respond_to :csv

  def index
    configure_csv_response(filename: 'logs.csv')

    response.stream.write CSV.generate_line(%w(session_id message time))

    Session.each do |session|
      session.logs.each do |log|
        response.stream.write CSV.generate_line([session.id, log.message, exact_time(log.time)])
      end
    end
    response.stream.close
  end
end
