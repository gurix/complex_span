class LogsController < ApplicationController
  respond_to :html

  def index
    @logs = Session.all.map(&:logs).flatten

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = 'attachment; filename="logs"'
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
end
