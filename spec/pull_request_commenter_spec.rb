require 'spec_helper'

describe PullRequestCommenter do
  describe '#comment_approved' do
    it 'makes the right comment on the issue' do
      ENV.stub(:[]).with('CONTRIBOT_BOT_NAME').and_return('login')
      ENV.stub(:[]).with('CONTRIBOT_BOT_TOKEN').and_return('token')
      Octokit::Client.should_receive(:new).with(login: 'login', oauth_token: 'token').and_call_original
      message = "Thanks for signing the CLA, @user123! This pull request is ready for review."
      Octokit::Client.any_instance.should_receive(:add_comment).with('octocat/foobar', 5, message)

      PullRequestCommenter.comment_approved(repo: 'octocat/foobar', issue_id: 5, pull_requester: 'user123')
    end
  end

  describe '#comment_needs_approval' do
    it 'makes the right comment on the issue' do
      ENV.stub(:[]).with('CONTRIBOT_BOT_NAME').and_return('login')
      ENV.stub(:[]).with('CONTRIBOT_BOT_TOKEN').and_return('token')
      Octokit::Client.should_receive(:new).with(login: 'login', oauth_token: 'token').and_call_original
      message = "Thank you for the pull request, @user123. It looks like you haven't signed our CLA yet."
      Octokit::Client.any_instance.should_receive(:add_comment).with('octocat/foobar', 5, message)

      PullRequestCommenter.comment_needs_approval(repo: 'octocat/foobar', issue_id: 5, pull_requester: 'user123')
    end
  end
end
