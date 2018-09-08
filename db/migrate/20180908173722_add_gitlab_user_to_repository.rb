class AddGitlabUserToRepository < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :gitlab_user, :string
  end
end
