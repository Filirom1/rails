class SessionsController < ApplicationController
  def create
puts request.env['omniauth.auth']
    if request.env['omniauth.auth']['provider']=="gitlab"
      puts ">>>>>>>>>"
      session[:gitlab] = {
        token: request.env['omniauth.auth']['credentials']['token'],
        user: request.env['omniauth.auth']['info']['username'],
      }
    end

    puts request.env['omniauth.auth']
    if request.env['omniauth.auth']['provider']=="keycloak"
      session[:keycloak] = {
        user: request.env['omniauth.auth']['info']['username'],
      }
    end
    redirect_to '/'
  end
end
