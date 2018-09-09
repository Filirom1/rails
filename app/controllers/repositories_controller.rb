require 'rest-client'

class RepositoriesController < ApplicationController
  def index
    projects_str = RestClient.get('https://gitlab.com/api/v4/users/Filirom1/projects?private-token=Cw6TZwHf-7nNtrzYTsjL')
    projects = JSON.parse(projects_str, object_class: OpenStruct)
    @repositories = projects
  end
end
