require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Prophet
  class Application < Rails::Application

    config.autoload_paths += %W( #{Rails.root}/lib )

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end

S3_ACCESS_KEY = "AKIAJAFI6HWVUKD6TQ4Q"
S3_SECRET = "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"

PAPERCLIP_ROOT_PATH = ENV['PAPERCLIP_ROOT_PATH'] || "/#{Rails.env}"

Paperclip::Attachment.default_options.merge!({storage: :s3,
                                              s3_credentials: {
                                                  access_key_id: S3_ACCESS_KEY,
                                                  secret_access_key: S3_SECRET
                                              },
                                              s3_protocol: "https",
                                              s3_region: "us-west-1",
                                              path: PAPERCLIP_ROOT_PATH + "/:user/:basename/:style.:extension",
                                              bucket: "prophet2"
                                             })

GENERIC_PAPERCLIP_SETTINGS = {
    :path => PAPERCLIP_ROOT_PATH + "/:class_name/:attachment/:hashed_path/:record_id_:style.:extension"
}