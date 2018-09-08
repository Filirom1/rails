class AddFieldnameToRepository < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :user, :string
  end
end
