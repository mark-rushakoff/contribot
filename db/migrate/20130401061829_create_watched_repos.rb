class CreateWatchedRepos < ActiveRecord::Migration
  def change
    create_table :watched_repos do |t|
      t.string :owner
      t.string :repo_name
      t.string :event
      t.string :secret

      t.timestamps
    end
  end
end
