module PullRequestCommenter
  class << self
    def comment_approved(opts)
      client = Octokit::Client.new(login: ENV['CONTRIBOT_BOT_NAME'], oauth_token: ENV['CONTRIBOT_BOT_TOKEN'])
      message = "Thanks for signing the CLA, @#{opts[:pull_requester]}! This pull request is ready for review."
      client.add_comment(opts[:repo], opts[:issue_id], message)
    end

    def comment_needs_approval(opts)
      client = Octokit::Client.new(login: ENV['CONTRIBOT_BOT_NAME'], oauth_token: ENV['CONTRIBOT_BOT_TOKEN'])
      message = "Thank you for the pull request, @#{opts[:pull_requester]}. It looks like you haven't signed our CLA yet."
      client.add_comment(opts[:repo], opts[:issue_id], message)
    end
  end
end
