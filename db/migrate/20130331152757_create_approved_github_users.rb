class CreateApprovedGithubUsers < ActiveRecord::Migration
  def change
    create_table :approved_github_users do |t|
      t.string :login

      t.timestamps
    end

    add_index :approved_github_users, :login, unique: true
  end
end
