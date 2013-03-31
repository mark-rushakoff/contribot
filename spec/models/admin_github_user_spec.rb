require 'spec_helper'

describe AdminGithubUser do
  it { should validate_uniqueness_of(:login) }

  describe '.is_admin?' do
    let(:admin_user) { double(login: 'an_admin') }
    let(:normal_user) { double(login: 'normal_user') }

    before { Fabricate(:admin_github_user, login: 'an_admin') }

    it 'is true when there is an entry for that user' do
      expect(AdminGithubUser.is_admin?(admin_user)).to eq(true)
    end
    it 'is false when there is no entry for that user' do
      expect(AdminGithubUser.is_admin?(normal_user)).to eq(false)
    end
  end

  describe '.add_admin!' do
    it 'creates an admin with the given login' do
      expect(AdminGithubUser.find_by_login('somebody')).to be_nil
      AdminGithubUser.add_admin!('somebody')
      expect(AdminGithubUser.find_by_login('somebody')).not_to be_nil
    end
  end

  describe '.remove_admin!' do
    it 'deletes an admin with the given login' do
      AdminGithubUser.add_admin!('somebody')
      expect(AdminGithubUser.find_by_login('somebody')).not_to be_nil
      AdminGithubUser.remove_admin!('somebody')
      expect(AdminGithubUser.find_by_login('somebody')).to be_nil
    end
  end

  describe '.all_admins' do
    it 'returns a list of all the admin logins' do
      %w(u1 u2 u3).each { |u| AdminGithubUser.add_admin!(u) }

      expect(AdminGithubUser.all_admins).to match_array(%w(u1 u2 u3))
    end
  end
end
