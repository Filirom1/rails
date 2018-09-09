class HomeController < ApplicationController
  def index
    return redirect_to  "/auth/keycloak" unless session[:keycloak]
  end
end
