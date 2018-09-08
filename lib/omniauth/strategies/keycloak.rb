require 'omniauth-oauth2'
require 'jwt'

module OmniAuth
  module Strategies
    class Keycloak < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "keycloak"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        :authorize_url => "http://localhost:8080/auth/realms/toto/protocol/openid-connect/auth",
        :token_url => "http://localhost:8080/auth/realms/toto/protocol/openid-connect/token",
        :site => "http://localhost:8080/auth/realms/toto/protocol/openid-connect/",
      }

      option :redirect_url

      option :authorize_params, {
        :scope => "offline_access openid profile"
      }

      option :token_params, {
        :scope => "offline_access openid profile"
      }

      info do
        jwt = ::JWT.decode(access_token['id_token'], nil, false).first
        {
          :username => jwt['preferred_username'],
          :email => jwt['email']
        }
      end

      extra do
        {
          'id_token' => access_token['id_token'],
        }
      end

      private

      def callback_url
        options.redirect_url || (full_host + script_name + callback_path)
      end
    end
  end
end
