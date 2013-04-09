module PullRequestCommenter
  class << self
    def comment_approved(opts)
      client = GithubBot.build
      pull_requester = opts.fetch(:pull_requester)
      repo = opts.fetch(:repo)
      issue_id = opts.fetch(:issue_id)
      message = "Thanks for signing the CLA, @#{pull_requester}! This pull request is ready for review."
      client.add_comment(repo, issue_id, message)
      Rails.logger.info("Commented on pull request from approved user #{pull_requester} on #{repo} ##{issue_id}")
    end

    def comment_needs_approval(opts)
      client = GithubBot.build
      pull_requester = opts.fetch(:pull_requester)
      repo = opts.fetch(:repo)
      issue_id = opts.fetch(:issue_id)
      message = "Thank you for the pull request, @#{pull_requester}. It looks like you haven't signed our CLA yet."
      client.add_comment(repo, issue_id, message)
      Rails.logger.info("Commented on pull request from unapproved user #{pull_requester} on #{repo} ##{issue_id}")
    end
  end
end
