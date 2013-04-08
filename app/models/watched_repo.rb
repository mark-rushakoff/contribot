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

    def stop_watching_pull_requests!(owner, repo_name, callback_url)
      repo = WatchedRepo.find_by_owner_and_repo_name(owner, repo_name)

      if RepoHookSubscriber.unsubscribe(repo, callback_url)
        repo.delete
      else
        raise "Error unsubscribing from repo hook"
      end
    end
  end
end
