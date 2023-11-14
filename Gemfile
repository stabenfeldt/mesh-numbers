source 'https://rubygems.org'

# Looking to use the Edge version? gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'

gem 'slim-rails', '>= 3.1.3'
gem 'slim'
gem 'httparty', '~> 0.15.4'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use Rack Timeout. Read more: https://github.com/heroku/rack-timeout
gem 'rack-timeout', '~> 0.4'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use PostgreSQL as the database for Active Record
gem 'pg', '~> 0.18'

# Use Redis Rails to set up a Redis backed Cache and / or Session
gem 'redis-rails', '~> 5.0.2.0'

# Use Sidekiq as a background job processor through Active Job
gem 'sidekiq', '~> 4.2'

# Use Clockwork for recurring background tasks without needing cron
# gem 'clockwork', '~> 2.0'

# Use Kaminari for pagination
# gem 'kaminari', '~> 0.16'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.7'

# Use Uglifier as the compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jQuery as the JavaScript library
gem 'jquery-rails', '>= 4.2.2'

# Use Turbolinks. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Use Bootstrap SASS for Bootstrap support
gem 'bootstrap-sass', '~> 3.3'

# Use Font Awesome Rails for Font Awesome icons
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.2'

group :test do
end



group :development, :test do
  gem 'timecop'
  gem 'rspec-rails', '~> 3.6', '>= 3.6.1'
  # Call 'byebug' anywhere in your code to drop into a debugger console
  gem 'byebug', platform: :mri
  gem 'rails-controller-testing', '>= 1.0.3'
end

group :development do
  gem 'guard'
  gem 'guard-rspec', require: false

  # Enable a debug toolbar to help profile your application
  gem 'rack-mini-profiler', '~> 0.10'

  # Access an IRB console on exception pages or by using <%= console %>
  gem 'web-console', '~> 3.4.0'

  # Get notified of file changes. Read more: https://github.com/guard/listen
  gem 'listen', '~> 3.0.5'

  # Use Spring. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
