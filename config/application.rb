require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rails5test
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # config.middleware.insert_before ActionDispatch::ParamsParser, "CatchJsonParseErrors"

    config.autoload_paths += %W(#{config.root}/app/domain/repositories)
    config.autoload_paths += %W(#{config.root}/app/domain/services)

    config.exceptions_app = self.routes
  end
end

