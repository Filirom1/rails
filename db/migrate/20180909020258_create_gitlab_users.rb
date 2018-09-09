class CreateGitlabUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :gitlab_users do |t|
      t.string :name
      t.string :token

      t.timestamps
    end
  end
end
