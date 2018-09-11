require 'omniauth/strategies/keycloak'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :gitlab, ENV['GITLAB_KEY'], ENV['GITLAB_SECRET']
  provider :keycloak, ENV['KEYCLOAK_KEY'], ENV['KEYCLOAK_SECRET']
end
