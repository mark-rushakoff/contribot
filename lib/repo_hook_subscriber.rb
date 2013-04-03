module RepoHookSubscriber
  class << self
    def subscribe(watched_repo, callback_url)
      url = "https://api.github.com/hub?client_id=#{ENV['CONTRIBOT_GITHUB_CLIENT_ID']}&client_secret=#{ENV['CONTRIBOT_GITHUB_CLIENT_SECRET']}"
      HTTParty.post(url, body: {
        'hub.mode' => 'subscribe',
        'hub.topic' => "https://github.com/#{watched_repo.owner}/#{watched_repo.repo_name}/events/#{watched_repo.event}",
        'hub.callback' => callback_url,
        'hub.secret' => watched_repo.secret
      }).success?
    end
  end
end
