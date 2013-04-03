require 'spec_helper'

describe RepoHookSubscriber do
  describe '.subscribe' do
    it 'makes the right request' do
      repo = double(owner: 'octocat', repo_name: 'foobar', event: 'pull_request', secret: 'a_hex_string')
      ENV.stub(:[]).with('CONTRIBOT_GITHUB_CLIENT_ID').and_return('gh_id')
      ENV.stub(:[]).with('CONTRIBOT_GITHUB_CLIENT_SECRET').and_return('gh_secret')

      callback_url = 'http://example.com/callback'
      stubbed_request = stub_request(:post, "https://api.github.com/hub?client_id=gh_id&client_secret=gh_secret").
         with(:body => "hub.mode=subscribe&hub.topic=https%3A%2F%2Fgithub.com%2Foctocat%2Ffoobar%2Fevents%2Fpull_request&hub.callback=http%3A%2F%2Fexample.com%2Fcallback&hub.secret=a_hex_string").
         to_return(:status => 200, :body => "", :headers => {})

      expect(RepoHookSubscriber.subscribe(repo, callback_url)).to eq(true)

      expect(stubbed_request).to have_been_requested
    end

    it 'returns false on a failed request' do
      repo = double(owner: 'octocat', repo_name: 'foobar', event: 'pull_request', secret: 'a_hex_string')
      ENV.stub(:[]).with('CONTRIBOT_GITHUB_CLIENT_ID').and_return('gh_id')
      ENV.stub(:[]).with('CONTRIBOT_GITHUB_CLIENT_SECRET').and_return('gh_secret')

      callback_url = 'http://example.com/callback'
      stubbed_request = stub_request(:post, "https://api.github.com/hub?client_id=gh_id&client_secret=gh_secret").
         with(:body => "hub.mode=subscribe&hub.topic=https%3A%2F%2Fgithub.com%2Foctocat%2Ffoobar%2Fevents%2Fpull_request&hub.callback=http%3A%2F%2Fexample.com%2Fcallback&hub.secret=a_hex_string").
         to_return(:status => 500, :body => "", :headers => {})

      expect(RepoHookSubscriber.subscribe(repo, callback_url)).to eq(false)

      expect(stubbed_request).to have_been_requested
    end
  end
end
