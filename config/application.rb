require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Musubi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
   
    # pdf自動作成
    config.eager_load_paths += %W(#{Rails.root}/lib/pdf)
    # deviseエラーメッセージの日本語化
    config.i18n.default_locale = :ja
    # 時間を日本に設定
    config.time_zone = 'Tokyo' 
  end
end
