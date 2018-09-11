require 'omniauth-oauth2'

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

      option :token_params, {
        :scope => "offline_access"
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ raw_info['id'] }

      info do
        {
          :name => raw_info['name'],
          :email => raw_info['email']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token#.get('/userinfo').parsed
      end

      private

      def callback_url
        options.redirect_url || (full_host + script_name + callback_path)
      end
    end
  end
end
