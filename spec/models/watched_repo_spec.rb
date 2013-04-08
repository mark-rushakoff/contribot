require 'spec_helper'

describe WatchedRepo do
  it { should validate_presence_of(:owner) }
  it { should validate_presence_of(:repo_name) }
  it { should validate_presence_of(:event) }
  it { should validate_presence_of(:secret) }
  it { should validate_uniqueness_of(:event).scoped_to(:owner, :repo_name) }

  let(:callback_url) { 'http://example.com/callback' }

  describe '.watch_pull_requests!' do
    it 'makes a proper request to GitHub and saves the record' do
      SecureRandom.stub(:hex).with(32).and_return('a_hex_string')
      RepoHookSubscriber.should_receive(:subscribe).with(an_instance_of(WatchedRepo), callback_url) do |repo, callback|
        expect(repo.owner).to eq('octocat')
        expect(repo.repo_name).to eq('foobar')
        expect(repo.event).to eq('pull_request')
        expect(repo.secret).to eq('a_hex_string')

        repo.should_receive(:save!)
        true
      end

      WatchedRepo.watch_pull_requests!('octocat', 'foobar', callback_url)
    end

    it 'raises if the subscription attempt fails' do
      SecureRandom.stub(:hex).with(32).and_return('a_hex_string')
      RepoHookSubscriber.should_receive(:subscribe).with(an_instance_of(WatchedRepo), callback_url) do |repo, callback|
        expect(repo.owner).to eq('octocat')
        expect(repo.repo_name).to eq('foobar')
        expect(repo.event).to eq('pull_request')
        expect(repo.secret).to eq('a_hex_string')

        repo.should_not_receive(:save!)
        false
      end

      expect {
        WatchedRepo.watch_pull_requests!('octocat', 'foobar', callback_url)
      }.to raise_error
    end
  end

  describe '.stop_watching_pull_requests!' do
    let(:repo) { Fabricate(:watched_repo, owner: 'octocat', repo_name: 'foobar') }

    it 'makes a proper request to GitHub and deletes the record' do
      RepoHookSubscriber.should_receive(:unsubscribe).with(repo, callback_url) do |repo|
        repo.should_receive(:delete)
        true
      end

      WatchedRepo.stop_watching_pull_requests!('octocat', 'foobar', callback_url)
    end

    it 'raises if the subscription attempt fails' do
      RepoHookSubscriber.should_receive(:unsubscribe).with(repo, callback_url) do |repo|
        repo.should_not_receive(:delete)
        false
      end

      expect {
        WatchedRepo.stop_watching_pull_requests!('octocat', 'foobar', callback_url)
      }.to raise_error
    end
  end
end
