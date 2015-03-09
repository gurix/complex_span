class RetrievalClicksController < ApplicationController
  respond_to :html

  def index
    trials = Session.all.map(&:trials).flatten

    @retrieval_clicks = trials.map(&:retrieval_clicks).flatten

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = 'inline'
        headers['Content-Type'] = 'text/plain'
        # headers['Content-Disposition'] = 'attachment; filename="retrieval_clicks"'
        # headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
end
