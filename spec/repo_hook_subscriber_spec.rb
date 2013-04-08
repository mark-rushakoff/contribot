require 'spec_helper'

describe RepoHookSubscriber do
  %w(subscribe unsubscribe).each do |mode|
    describe ".#{mode}" do
      it 'makes the right request' do
      repo = double(owner: 'octocat', repo_name: 'foobar', event: 'pull_request', secret: 'a_hex_string')
      ENV.stub(:[]).with('CONTRIBOT_BOT_TOKEN').and_return('a_token')

      callback_url = 'http://example.com/callback'
      stubbed_request = stub_request(:post, "https://api.github.com/hub?access_token=a_token").
        with(:body => "hub.mode=#{mode}&hub.topic=https%3A%2F%2Fgithub.com%2Foctocat%2Ffoobar%2Fevents%2Fpull_request&hub.callback=http%3A%2F%2Fexample.com%2Fcallback&hub.secret=a_hex_string").
        to_return(:status => 200, :body => "", :headers => {})

      expect(RepoHookSubscriber.__send__(mode.to_sym, repo, callback_url)).to eq(true)

      expect(stubbed_request).to have_been_requested
    end

    it 'returns false on a failed request' do
      $stderr.stub(:puts) # suppress error output for this spec
      repo = double(owner: 'octocat', repo_name: 'foobar', event: 'pull_request', secret: 'a_hex_string')
      ENV.stub(:[]).with('CONTRIBOT_BOT_TOKEN').and_return('a_token')

      callback_url = 'http://example.com/callback'
      stubbed_request = stub_request(:post, "https://api.github.com/hub?access_token=a_token").
        with(:body => "hub.mode=#{mode}&hub.topic=https%3A%2F%2Fgithub.com%2Foctocat%2Ffoobar%2Fevents%2Fpull_request&hub.callback=http%3A%2F%2Fexample.com%2Fcallback&hub.secret=a_hex_string").
        to_return(:status => 500, :body => "", :headers => {})

      expect(RepoHookSubscriber.__send__(mode.to_sym, repo, callback_url)).to eq(false)

      expect(stubbed_request).to have_been_requested
    end
    end
  end
end
