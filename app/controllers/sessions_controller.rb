class SessionsController < ApplicationController
  def create
puts request.env['omniauth.auth']
    session[:gitlab] = {
      token: request.env['omniauth.auth']['credentials']['token'],
      user: request.env['omniauth.auth']['info']['username'],
    }

    puts request.env['omniauth.auth']['credentials']['refresh_token']
    session[:keycloak] = {
    #  refresh_token: request.env['omniauth.auth']['credentials']['refresh_token']
    }
    redirect_to '/'
  end
end
