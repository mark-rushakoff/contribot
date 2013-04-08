module RepoHookSubscriber
  class << self
    def subscribe(watched_repo, callback_url)
      subscription_request(watched_repo, callback_url, 'subscribe')
    end

    def unsubscribe(watched_repo, callback_url)
      subscription_request(watched_repo, callback_url, 'unsubscribe')
    end

    private
    def subscription_request(watched_repo, callback_url, mode)
      # Authenticate via OAuth2 token: http://developer.github.com/v3/#authentication
      url = "https://api.github.com/hub?access_token=#{ENV['CONTRIBOT_BOT_TOKEN']}"
      resp = HTTParty.post(url, body: {
        'hub.mode' => mode,
        'hub.topic' => "https://github.com/#{watched_repo.owner}/#{watched_repo.repo_name}/events/#{watched_repo.event}",
        'hub.callback' => callback_url,
        'hub.secret' => watched_repo.secret
      })

      return true if resp.success?

      $stderr.puts("Subscription failure: #{resp.inspect}")
      false
    end
  end
end
