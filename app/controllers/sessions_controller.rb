class SessionsController < ApplicationController
  respond_to :html

  def create
    @session = Session.create session_params
    if @session.valid?
      render json: @session
    else
      render json: @session.errors, status: 500
    end
  end

  def session_params
    params.require(:session).permit!
  end
end
