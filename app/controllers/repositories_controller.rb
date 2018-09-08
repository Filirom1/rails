require 'rest-client'
require 'yaml'

class RepositoriesController < ApplicationController
  def index
    projects_str = RestClient.get("https://gitlab.com/api/v4/users/#{session[:gitlab]['user']}/projects", :authorization => "Bearer #{session[:gitlab]['token']}")
    projects = JSON.parse(projects_str, object_class: OpenStruct)
    @repositories = projects
    @scopes = [{
      id: 'urn:company:a',
      description: 'API A',
    }, {
      id: 'urn:company:b',
      description: 'API B',
    }, {
      id: 'urn:company:c',
      description: 'API C',
    }, {
      id: 'urn:company:d',
      description: 'API D',
    }, {
      id: 'urn:company:e',
      description: 'API E',
    }, {
      id: 'urn:company:f',
      description: 'API F',
    }]
  end

  def create
    scopes = []
    params.each do |k,v|
      next unless k.start_with? 'urn:'
      next unless v == '1' 
      scopes << k
    end

    id = params['id'].to_i
    scopes_str = scopes.join(',')
    repository = Repository.where(id: id).first_or_create()
    repository.scopes = scopes_str
    repository.enabled = ! scopes.empty?
    repository.user = session[:keycloak]['user']
    repository.gitlab_user = session[:gitlab]['user']
    repository.save
  end
end
