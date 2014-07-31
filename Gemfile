source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'bootstrap-sass', '~> 3.2.0'
#gem 'bcrypt-ruby', '3.0.1'
#gem 'faker', '1.0.1'
#gem 'will_paginate', '3.0.3'
#gem 'bootstrap-will_paginate', '0.0.6'
gem "yelpster", "~> 1.1.4"
gem "figaro", "~> 0.7.0"
gem "custom_error_message", "~> 1.1.1"
#gem "sitemap_generator", "~> 4.2.0"
gem 'newrelic_rpm'

# see bootstrap install page for why these are needed
# https://github.com/twbs/bootstrap-sass
gem 'sprockets-rails', '=2.0.0.backport1'
gem 'sprockets', '=2.2.2.backport2'
gem 'sass-rails', github: 'guilleiguaran/sass-rails', branch: 'backport'

group :development, :test do
  gem 'sqlite3', '1.3.5'
  gem 'rspec-rails', '2.11.0'
  gem 'guard-rspec', '1.2.1'
  gem 'guard-spork', '1.4.2'
  gem 'spork', '0.9.2'
  gem 'annotate', '2.5.0'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  #gem 'sass-rails',   '3.2.5'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
end

gem 'jquery-rails', '2.0.2'

group :test do
  gem 'capybara', '1.1.2'
  gem 'rb-inotify', '~> 0.9'
  gem 'libnotify', '0.5.9'
  gem 'factory_girl_rails', '4.1.0'
end

group :production do
  gem 'pg', '0.12.2'
end