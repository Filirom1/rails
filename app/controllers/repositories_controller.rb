require 'rest-client'
require 'yaml'

class RepositoriesController < ApplicationController
  def index
    return redirect_to  "/auth/gitlab" unless session[:gitlab]

    @scopes = Rails.configuration.allowed_scopes.split " "
    username = session[:gitlab]['user']
    token = GitlabUser.where(name: username).first.token
    projects_str = RestClient.get("https://gitlab.com/api/v4/users/#{username}/projects", :authorization => "Bearer #{token}")
    projects = JSON.parse(projects_str)
    @repositories = projects.map do |project|
      if Repository.exists?(project['id'])
        repository = Repository.find(project['id'])
        project['scopes'] = @scopes.map do |s|
          enabled = repository.scopes.include?(s)
          {id: s, name: s.gsub(/.*:/, ''), enabled: enabled}
        end
        puts project.inspect
      else
        project['scopes'] = @scopes.map do |s|
          {id: s, name: s.gsub(/.*:/, '')}
        end
      end
      project
    end
  end

  def create
    scopes = []
    params.each do |k,v|
      next unless k.start_with? 'urn:'
      next unless v == 'yes' 
      scopes << k
    end

    id = params['id'].to_i
    scopes_str = scopes.join(' ')
    repository = Repository.where(id: id).first_or_create()
    repository.scopes = scopes_str
    repository.enabled = ! scopes.empty?
    repository.user = session[:keycloak]['user']
    repository.gitlab_user = session[:gitlab]['user']
    repository.name = params['name']
    repository.save
  end
end
