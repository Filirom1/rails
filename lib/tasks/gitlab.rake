require 'rest-client'

namespace :gitlab do
  desc "Publish new access tokens to Gitlab CI Secrets, and rotate refresh_token"
  task rotate_tokens: :environment do
    puts "test"
    Repository.where(enabled: true).each do |repository|
      puts "Rotating secret for Gitlab repo #{repository.name} (#{repository.id})"
      gitlab_user = GitlabUser.where(name: repository.gitlab_user).first
      gitlab_token = gitlab_user.token

      user = User.where(name: repository.user).first
      offline_token = user.offline_token

      keycloak_url = "http://localhost:8080/auth/realms/toto/protocol/openid-connect/token?scopes=#{repository.scopes}"
      token_resp = RestClient.post(keycloak_url, {
        refresh_token: offline_token,
        grant_type: 'refresh_token',
        client_id: ENV['KEYCLOAK_KEY'],
        client_secret: ENV['KEYCLOAK_SECRET']
      })

      resp = JSON.parse(token_resp.body)
      access_token = resp["acess_token"]
      new_offline_token = resp["refresh_token"]
      user.offline_token = new_offline_token
      user.save

      gitlab_url = "https://gitlab.com/api/v4/projects/#{repository.id}/variables"
      env_key="ACCESS_TOKEN"
      begin
        RestClient.put("#{gitlab_url}/#{env_key}", {value: access_token}, {authorization: "Bearer #{gitlab_token}"})
      rescue => RestClient::NotFound
        RestClient.post(gitlab_url, {key: env_key, value: access_token, protected: true}, {authorization: "Bearer #{gitlab_token}"})
      end
    end
  end

end
