module GithubBot
  class << self
    def build
      Octokit::Client.new(login: ENV['CONTRIBOT_BOT_NAME'], oauth_token: ENV['CONTRIBOT_BOT_TOKEN'])
    end
  end
end
