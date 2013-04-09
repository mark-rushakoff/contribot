require 'spec_helper'

describe GithubBot do
  describe '.build' do
    it 'makes an Octokit client with credentials from the environment' do
      ENV.stub(:[]).with('CONTRIBOT_BOT_NAME').and_return('bot_name')
      ENV.stub(:[]).with('CONTRIBOT_BOT_TOKEN').and_return('bot_token')
      Octokit::Client.stub(:new).with(login: 'bot_name', oauth_token: 'bot_token').and_return(a: 'bot')

      expect(GithubBot.build).to eq(a: 'bot')
    end
  end
end
