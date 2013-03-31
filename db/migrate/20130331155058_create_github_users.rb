class CreateGithubUsers < ActiveRecord::Migration
  def up
    create_table :github_users do |t|
      t.string :login
      t.boolean :admin
      t.boolean :approved

      t.timestamps
    end

    add_index :github_users, :login, unique: true

    drop_table :admin_github_users
    drop_table :approved_github_users
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
