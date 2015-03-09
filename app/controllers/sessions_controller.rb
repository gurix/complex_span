class SessionsController < ApplicationController
  respond_to :html

  skip_before_action :authenticate, only: :create

  def create
    @session = Session.create session_params.merge(ip_address: request.remote_ip)
    if @session.valid?
      render json: @session
    else
      render json: @session.errors, status: 500
    end
  end

  def index
    @sessions = Session.all
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = 'attachment; filename="sessions"'
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  def session_params
    params.require(:session).permit!
  end
end
