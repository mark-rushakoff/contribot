module PullRequestCommenter
  class << self
    def comment_approved(opts)
      client = Octokit::Client.new(login: ENV['CONTRIBOT_BOT_NAME'], oauth_token: ENV['CONTRIBOT_BOT_TOKEN'])
      pull_requester = opts[:pull_requester]
      repo = opts[:repo]
      issue_id = opts[:issue_id]
      message = "Thanks for signing the CLA, @#{pull_requester}! This pull request is ready for review."
      client.add_comment(repo, issue_id, message)
      Rails.logger.info("Commented on pull request from approved user #{pull_requester} on #{repo} ##{issue_id}")
    end

    def comment_needs_approval(opts)
      client = Octokit::Client.new(login: ENV['CONTRIBOT_BOT_NAME'], oauth_token: ENV['CONTRIBOT_BOT_TOKEN'])
      pull_requester = opts[:pull_requester]
      repo = opts[:repo]
      issue_id = opts[:issue_id]
      message = "Thank you for the pull request, @#{pull_requester}. It looks like you haven't signed our CLA yet."
      client.add_comment(repo, issue_id, message)
      Rails.logger.info("Commented on pull request from unapproved user #{pull_requester} on #{repo} ##{issue_id}")
    end
  end
end
