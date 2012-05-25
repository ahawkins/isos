source 'http://rubygems.org'

gem 'rails', '~>3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'twitter'

# Asset template engines
gem 'haml'
gem 'jquery-rails'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'mongoid'
gem 'bson_ext'
gem 'exifr'
gem 'fog'
gem 'rmagick'
gem 'mechanize'
gem 'heroku'
gem 'curb'

group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

group :production do
  gem "therubyracer-heroku", "~> 0.8.1.pre3"
  gem 'thin'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'debugger'
end

group :test do
  gem 'simplecov'
  gem 'webmock'
  gem 'mongoid-rspec'
end
