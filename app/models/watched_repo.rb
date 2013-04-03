class WatchedRepo < ActiveRecord::Base
  attr_accessible :owner, :repo_name

  validates :owner, :repo_name, :event, :secret, presence: true
  validates :event, uniqueness: {scope: [:owner, :repo_name]}

  class << self
    def watch_pull_requests!(owner, repo_name, callback_url)
      repo = WatchedRepo.new
      repo.owner = owner
      repo.repo_name = repo_name
      repo.event = 'pull_request'
      repo.secret = SecureRandom.hex(32)

      if RepoHookSubscriber.subscribe(repo, callback_url)
        repo.save!
      else
        raise "Error subscribing to repo hook"
      end
    end
  end
end
