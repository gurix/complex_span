class PresentationsController < ApplicationController
  respond_to :html

  def index
    trials = Session.all.map(&:trials).flatten

    @presentations = trials.map(&:words).flatten

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = 'attachment; filename="presentations"'
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
end
