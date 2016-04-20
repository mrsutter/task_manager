require File.expand_path('../boot', __FILE__)

require 'rails/all'

require 'carrierwave'
require 'carrierwave/orm/activerecord'

Bundler.require(*Rails.groups)

module TaskManager
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec
    end

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales',
                                                 '**', '*.{rb,yml}')]

    config.filter_parameters += [:password]

    config.time_zone = 'Europe/Moscow'
    config.i18n.default_locale = :ru

    config.active_record.raise_in_transactional_callbacks = true
  end
end
