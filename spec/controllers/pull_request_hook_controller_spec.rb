require 'spec_helper'

describe PullRequestHookController do
  let(:new_pull_request_json) { IO.read(Rails.root.join(*%w(spec fixtures new_pull_request.json))) }

  describe 'POST create' do
    it 'comments with ok to pull when the user is approved' do
      GithubUser.should_receive(:approved?).with('mark-rushakoff').and_return(true)
      PullRequestCommenter.should_receive(:comment_approved).with(repo: "mark-rushakoff/contribot-sandbox", issue_id: 1, pull_requester: 'mark-rushakoff')
      post :create, payload: new_pull_request_json
      response.should be_success
    end

    it 'comments with signature needed when the user is approved' do
      GithubUser.should_receive(:approved?).with('mark-rushakoff').and_return(false)
      PullRequestCommenter.should_receive(:comment_needs_approval).with(repo: "mark-rushakoff/contribot-sandbox", issue_id: 1, pull_requester: 'mark-rushakoff')
      post :create, payload: new_pull_request_json
      response.should be_success
    end
  end
end
