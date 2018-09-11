require 'rest-client'
require 'yaml'

class RepositoriesController < ApplicationController
  def index
    projects_str = RestClient.get("https://gitlab.com/api/v4/users/#{session[:gitlab]['user']}/projects", :authorization => "Bearer #{session[:gitlab]['token']}")
    projects = JSON.parse(projects_str, object_class: OpenStruct)
    @repositories = projects
  end
end
