class SessionsController < ApplicationController
  include ActionController::Live
  respond_to :html

  skip_before_action :authenticate, only: [:create, :update]

  def create
    @session = Session.create session_params.merge(ip_address: request.remote_ip)
    if @session.valid?
      render json: @session
    else
      render json: @session.errors, status: 500
    end
  end

  def update
    @session = Session.find params[:id]
    @session.update_attributes session_params
    if @session.valid?
      render json: @session
    else
      render json: @session.errors, status: 500
    end
  end

  def index
    @sessions = Session
    respond_to do |format|
      format.csv do
        configure_csv_response(filename: 'sessions.csv')

        response.stream.write CSV.generate_line(csv_header)

        @sessions.each do |session|
          response.stream.write CSV.generate_line([session.id, session.created_at, session.updated_at, session.age, session.sincerity, session.gender,
                                                   session.education, session.ip_address, session.language, session.logs.count, session.trials.count] +
                                                   session.system_information.values)
        end
        response.stream.close
      end
    end
  end

  def session_params
    params.require(:session).permit!
  end

  def csv_header
    system_information_headers = %w(screen_width screen_height navigator_user_agent navigator_platform window_innerHeight window_innerWidth window_screenX
                                    window_screenY window_pageXOffset window_pageYOffset)
    headers = %w(id created_at updated_at age sincerity gender education ip_address language number_of_logs number_of_trials)
    headers + system_information_headers.map { |system_information_header| "sys_#{system_information_header}" }
  end
end
