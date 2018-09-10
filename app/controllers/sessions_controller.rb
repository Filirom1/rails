class SessionsController < ApplicationController
  def create
    session[:user] = request.env['omniauth.auth']
    redirect_to '/'
  end
end
