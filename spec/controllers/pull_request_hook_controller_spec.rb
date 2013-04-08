require 'spec_helper'

describe PullRequestHookController do
  let(:new_pull_request_json) { IO.read(Rails.root.join(*%w(spec fixtures new_pull_request.json))) }

  describe 'POST create' do
    before do
      # watched repo exists in database
      Fabricate(:watched_repo, owner: 'mark-rushakoff', repo_name: 'contribot-sandbox')

      # act like checksums match
      OpenSSL::HMAC.stub(hexdigest: 'some_sha1')
      request.env['X-Hub-Signature'] = 'some_sha1'
    end

    it 'comments with ok to pull when the user is approved' do
      GithubUser.should_receive(:approved?).with('mark-rushakoff').and_return(true)
      PullRequestCommenter.should_receive(:comment_approved).with(repo: "mark-rushakoff/contribot-sandbox", issue_id: 1, pull_requester: 'mark-rushakoff')
      post :create, owner: 'mark-rushakoff', repo_name: 'contribot-sandbox', payload: new_pull_request_json
      response.should be_success
    end

    it 'comments with signature needed when the user is approved' do
      GithubUser.should_receive(:approved?).with('mark-rushakoff').and_return(false)
      PullRequestCommenter.should_receive(:comment_needs_approval).with(repo: "mark-rushakoff/contribot-sandbox", issue_id: 1, pull_requester: 'mark-rushakoff')
      post :create, owner: 'mark-rushakoff', repo_name: 'contribot-sandbox', payload: new_pull_request_json
      response.should be_success
    end

    it 'does nothing if the action is not "opened"' do
      payload = JSON.parse(new_pull_request_json)
      payload['action'] = 'closed'

      GithubUser.should_not_receive(:approved?)
      PullRequestCommenter.should_not_receive(:comment_needs_approval)
      PullRequestCommenter.should_not_receive(:comment_approved)

      post :create, owner: 'mark-rushakoff', repo_name: 'contribot-sandbox', payload: payload.to_json
      response.should be_success
    end

    it 'does nothing if the owner or repo are unrecognized' do
      GithubUser.should_not_receive(:approved?)
      PullRequestCommenter.should_not_receive(:comment_needs_approval)
      PullRequestCommenter.should_not_receive(:comment_approved)

      post :create, owner: 'some_user', repo_name: 'some_repo', payload: new_pull_request_json
      response.should be_success
    end

    it 'does nothing if the signature is wrong' do
      request.env['X-Hub-Signature'] = 'totally_different_sha1'
      GithubUser.should_not_receive(:approved?)
      PullRequestCommenter.should_not_receive(:comment_needs_approval)
      PullRequestCommenter.should_not_receive(:comment_approved)

      post :create, owner: 'mark-rushakoff', repo_name: 'contribot-sandbox', payload: new_pull_request_json
      response.should be_success
    end
  end
end
