source "https://rubygems.org"

ruby "3.3.5"

gem "rails",                  "~> 7.2.1"
gem "pg",                     "~> 1.2"
gem "puma",                   ">= 5.0"
gem "jquery-rails",           "~> 4.6"
gem "coffee-script",          "~> 2.4", ">= 2.4.1"
gem "sass-rails",             "~> 6.0"
gem "html2haml",              "~> 2.3"
gem "haml-rails",             "~> 2.1"
gem "bootstrap",              "~> 5.3", ">= 5.3.3"
gem "devise",                 "~> 4.9", ">= 4.9.4"
gem "simple_form",            "~> 5.3", ">= 5.3.1"
gem "sprockets-rails"
gem "importmap-rails"
gem "turbolinks",             "~> 5.2", ">= 5.2.1"
gem "stimulus-rails"
gem "tzinfo-data",                            platforms: %i[ windows jruby ]
gem "bootsnap",                               require: false
gem "datagrid",               "~> 1.8", ">= 1.8.2"
gem "kaminari"
gem "image_processing",       "~> 1.13"
gem "cocoon",                 "~> 1.2", ">= 1.2.15"
gem "ostruct",                "~> 0.6.0"

group :development, :test do
  gem "debug",                                platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman",                             require: false
  gem "rubocop-rails-omakase",                require: false
  gem "pry-rails",            "~> 0.3.11"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
