source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'dotenv-rails'
gem 'sprockets-rails', '2.3.3'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'

gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'devise'
gem 'slim'
gem 'sidekiq'
gem 'whenever', require: false
gem 'friendly_id'
gem "rack-cors", ">= 1.0.4"
gem 'clockwork'
gem 'kaminari'
gem 'ransack', github: 'activerecord-hackery/ransack'
gem 'sitemap_generator'
gem 'rack-attack'
gem 'bullet', group: 'development'
gem 'sidekiq-failures'
gem 'webpacker-pwa', group: :development
gem 'sidekiq-unique-jobs', '7.0.0.beta22'
gem 'groupdate' # optional
gem 'apexcharts'
gem 'impressionist', github: 'archetype2142/impressionist'
gem "sentry-raven"
gem "switch_user"
gem 'tunemygc'
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
