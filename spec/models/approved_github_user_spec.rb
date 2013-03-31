require 'spec_helper'

describe ApprovedGithubUser do
  it { should validate_uniqueness_of(:login) }

  describe '.is_approved?' do
    let(:approved_user) { double(login: 'approved_user') }
    let(:normal_user) { double(login: 'normal_user') }

    before { Fabricate(:approved_github_user, login: 'approved_user') }

    it 'is true when there is an entry for that user' do
      expect(ApprovedGithubUser.is_approved?(approved_user)).to eq(true)
    end
    it 'is false when there is no entry for that user' do
      expect(ApprovedGithubUser.is_approved?(normal_user)).to eq(false)
    end
  end

  describe '.add_approved!' do
    it 'creates an approved with the given login' do
      expect(ApprovedGithubUser.find_by_login('somebody')).to be_nil
      ApprovedGithubUser.add_approved!('somebody')
      expect(ApprovedGithubUser.find_by_login('somebody')).not_to be_nil
    end
  end

  describe '.remove_approved!' do
    it 'deletes an approved with the given login' do
      ApprovedGithubUser.add_approved!('somebody')
      expect(ApprovedGithubUser.find_by_login('somebody')).not_to be_nil
      ApprovedGithubUser.remove_approved!('somebody')
      expect(ApprovedGithubUser.find_by_login('somebody')).to be_nil
    end
  end

  describe '.all_approved' do
    it 'returns a list of all the approved logins' do
      %w(u1 u2 u3).each { |u| ApprovedGithubUser.add_approved!(u) }

      expect(ApprovedGithubUser.all_approved).to match_array(%w(u1 u2 u3))
    end
  end
end
