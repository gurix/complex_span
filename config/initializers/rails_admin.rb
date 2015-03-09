RailsAdmin.config do |config|
  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    # export
    bulk_delete
    show
    delete
  end

  config.navigation_static_label = 'Data export'
  config.navigation_static_links = {
    'Sessions' => '/sessions.csv',
    'Word presentations' => '/presentations.csv',
    'Retrieval clicks' => '/retrieval_clicks.csv',
    'Retrieval presentations' => '/retrievals.csv',
    'Logs' => '/logs.csv'
  }

  config.authorize_with do
    return true unless Rails.env.production?

    authenticate_or_request_with_http_basic do |_username, password|
      password == ENV['EXPORT_PASSWORD']
    end
  end
end
