if Rails.env.production?
  Raven.configure do |config|
    config.dsn = 'https://3a9d5dd9774f495f8ed5a1f39d93bd1f@o452740.ingest.sentry.io/5440619'
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
    config.environments = ["production"]
    config.excluded_exceptions = []
  end
end
