class PullRequestHookController < ApplicationController
  def create
    watched_repo = WatchedRepo.find_by_owner_and_repo_name(params[:owner], params[:repo_name])
    render nothing: true and return if watched_repo.nil?
    calculated_sha1 = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), watched_repo.secret, request.raw_post)
    Rails.logger.info("Repo secret: #{watched_repo.secret}")
    Rails.logger.info("Calculated sha1: #{calculated_sha1}")
    Rails.logger.info("Received sha1: #{request.headers['X-Hub-Signature']}")

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
