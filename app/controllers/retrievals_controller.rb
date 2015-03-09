class RetrievalsController < ApplicationController
  respond_to :html

  def index
    trials = Session.all.map(&:trials).flatten

    @retrievals = trials.map(&:retrievals).flatten

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = 'attachment; filename="retrievals"'
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
end
