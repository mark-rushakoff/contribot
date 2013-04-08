class PullRequestHookController < ApplicationController
  def create
    payload = JSON.parse(params[:payload])

    render nothing: true and return unless payload['action'] == 'opened'

    pull_requester = payload['sender']['login']
    opts = {
      repo: payload['repository']['full_name'],
      issue_id: payload['pull_request']['number'],
      pull_requester: pull_requester
    }

    if GithubUser.approved?(pull_requester)
      PullRequestCommenter.comment_approved(opts)
    else
      PullRequestCommenter.comment_needs_approval(opts)
    end

    render nothing: true
  end
end
