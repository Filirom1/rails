class CreateRepositories < ActiveRecord::Migration[5.1]
  def change
    create_table :repositories do |t|
      t.string :name
      t.boolean :enabled
      t.string :scopes

      t.timestamps
    end
  end
end
