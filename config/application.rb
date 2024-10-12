require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module CafePosSystem
  class Application < Rails::Application
    config.load_defaults 7.2
    config.generators do |g|
      g.assets false          # Disable stylesheet and JavaScript generation
      g.helper false          # Disable helper file generation
      g.test_framework nil    # Disable test file generation (can also be set to :rspec or other frameworks)
    end

    config.autoload_lib(ignore: %w[assets tasks])
    config.time_zone = "Asia/Phnom_Penh"

    config.assets.enabled = true
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.precompile += %w[ .svg .eot .woff .ttf]

    config.active_record.default_timezone = :local
    config.session_store :cookie_store, key: "health_management_session_#{Rails.env}"
  end
end
