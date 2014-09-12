module Spree
  class FrontendConfiguration < Preferences::Configuration
    preference :enabled, :boolean, default: true
    preference :locale, :string, :default => Rails.application.config.i18n.default_locale
  end
end
