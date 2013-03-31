class CreateAdminGithubUsers < ActiveRecord::Migration
  def change
    create_table :admin_github_users do |t|
      t.string :login

      t.timestamps
    end

    add_index :admin_github_users, :login, unique: true
  end
end
