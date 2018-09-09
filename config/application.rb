require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Project
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.allowed_scopes = "urn:company:service_a urn:company:service_b urn:company:service_c urn:company:service_d urn:company:service_e"
    config.web_console.whitelisted_ips = '10.0.2.2/32'

  end
end
