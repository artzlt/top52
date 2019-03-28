source "https://rubygems.org"

gem "rake"
gem "rails", "~> 4.1.2"
gem "activerecord-jdbcpostgresql-adapter", "~> 1.3"
gem "uglifier", ">= 1.3.0"
gem "chartkick"

gem "jquery-rails"
gem "jquery-ui-rails"
gem "select2-rails"

group :development do
  gem "letter_opener"
  gem "quiet_assets"
  gem "pry-rails"
  gem "rails-erd"
end

gem "sinatra", ">= 1.3.0", :require => nil

gem "mina"
gem "mina-rbenv-addons", require: false

gem "rollbar"

gem "foreman"
gem "puma"

gem "face",           path: "engines/face"
gem "authentication", path: "engines/authentication"
gem "core",           path: "engines/core"
gem "support",        path: "engines/support"
gem "sessions",       path: "engines/sessions"
gem "statistics",     path: "engines/statistics"
gem "wiki",           path: "engines/wiki"
gem "announcements",  path: "engines/announcements"

gem "config"
gem "decorators", "~> 1.0.0"

gem "will_paginate"
gem "will_paginate-bootstrap"
# gem "md_simple_editor" # doesn't support jruby
gem "ckeditor"

group :production do
  gem "whenever"
end

group :test do
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "factory_girl-seeds"
  gem "capybara"
  gem "poltergeist"
  gem "phantomjs", github: "colszowka/phantomjs-gem"
  gem "codeclimate-test-reporter", require: false
end
