class SessionsController < ApplicationController
  def create
    if request.env['omniauth.auth']['provider']=="gitlab"
      username = request.env['omniauth.auth']['info']['username']
      session[:gitlab] = {
        user: username,
      }
      user = GitlabUser.where(name: username).first_or_create()
      user.token = request.env['omniauth.auth']['credentials']['token']
      user.save()
    end

    if request.env['omniauth.auth']['provider']=="keycloak"
      username = request.env['omniauth.auth']['info']['username']
      session[:keycloak] = {
        user: username
      }
      user = User.where(name: username).first_or_create()
      user.offline_token = request.env['omniauth.auth']['credentials']['refresh_token']
      user.save
    end
    redirect_to '/'
  end
end
