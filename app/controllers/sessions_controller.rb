class SessionsController < ApplicationController
  respond_to :html

  def create
    @session = Session.create session_params
    render plain: 'Done!'
  end

  def session_params
    params.require(:session).permit!
  end
end
