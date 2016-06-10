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

    config.action_mailer.delivery_method = :smtp
    # SMTP settings for gmail
    config.action_mailer.smtp_settings = {
        :address              => "smtp.gmail.com",
        :port                 => 587,
        :user_name            => 'prophet.mailer1@gmail.com',
        :password             => 'WeAreProphet',
        :authentication       => "plain",
        :enable_starttls_auto => true
    }

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
                                                  path: PAPERCLIP_ROOT_PATH + "/users/:user/:style.:extension",
                                                  bucket: "prophet2"
                                                 })

    # prevent avatars < 10KB from opening as a StringIO instead of a TempFile
    OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
    OpenURI::Buffer.const_set 'StringMax', 0
  end
end