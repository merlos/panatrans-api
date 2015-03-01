require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PanatransApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    
    # accept CORS http://demisx.github.io/rails-api/2014/02/18/configure-accept-headers-cors.html
    config.action_dispatch.default_headers = {
      'Access-Control-Allow-Origin' => '*', #<-- instead of * you can set a domain
      'Access-Control-Request-Method' => %w{GET POST PUT DELETE}.join(",") # use %w{GET POST OPTIONS}.join(",") to allow the other methods
        }
    
  end
end
