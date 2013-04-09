require 'spec_helper'

describe PullRequestCommenter do
  describe '#comment_approved' do
    it 'makes the right comment on the issue' do
      bot = double()
      GithubBot.stub(build: bot)
      message = "Thanks for signing the CLA, @user123! This pull request is ready for review."
      bot.should_receive(:add_comment).with('octocat/foobar', 5, message)

      PullRequestCommenter.comment_approved(repo: 'octocat/foobar', issue_id: 5, pull_requester: 'user123')
    end
  end

  describe '#comment_needs_approval' do
    it 'makes the right comment on the issue' do
      bot = double()
      GithubBot.stub(build: bot)
      message = "Thank you for the pull request, @user123. It looks like you haven't signed our CLA yet."
      bot.should_receive(:add_comment).with('octocat/foobar', 5, message)

      PullRequestCommenter.comment_needs_approval(repo: 'octocat/foobar', issue_id: 5, pull_requester: 'user123')
    end
  end
end
