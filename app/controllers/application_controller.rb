class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # By default, protect everything
  before_action :set_locale, :authenticate

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  protected

  def authenticate
    return true unless Rails.env.production?

    authenticate_or_request_with_http_basic do |_username, password|
      password == ENV['EXPORT_PASSWORD']
    end
  end

  def exact_time(date_time)
    # Formating according ISO 8601
    date_time.strftime('%Y-%m-%dT%H:%M:%S.%L%Z') if date_time
  end

  def configure_csv_response(options_hash)
    options_hash.reverse_merge!(filename: 'noname.csv')
    response.headers['Content-Disposition'] = "attachment; filename='#{options_hash[:filename]}'"
    response.headers['Content-Type'] ||= 'text/csv'
  end
end
