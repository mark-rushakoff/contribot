require 'spec_helper'

describe GithubUser do
  it { should validate_uniqueness_of(:login) }

  it 'defaults to non-admin, non-approved' do
    user = GithubUser.create!(login: 'somebody')
    expect(user).not_to be_admin
    expect(user).not_to be_approved
  end

  describe '.add_approved!' do
    it 'creates an approved with the given login' do
      expect(GithubUser.find_by_login('somebody')).to be_nil
      GithubUser.add_approved!('somebody')
      expect(GithubUser.find_by_login('somebody')).to be_approved
    end

    it 'sets the user to approved if the user already exists' do
      GithubUser.create!(login: 'somebody')
      GithubUser.add_approved!('somebody')
      expect(GithubUser.find_by_login('somebody')).to be_approved
    end
  end

  describe '.unapprove!' do
    it 'deletes an approved with the given login' do
      GithubUser.add_approved!('somebody')
      expect(GithubUser.find_by_login('somebody')).not_to be_nil
      GithubUser.unapprove!('somebody')
      expect(GithubUser.find_by_login('somebody')).not_to be_approved
    end

    it 'does not care if the login does not exist' do
      expect(GithubUser.find_by_login('somebody')).to be_nil
      expect { GithubUser.unapprove!('somebody') }.not_to raise_error
    end
  end

  describe '.all_approved' do
    it 'returns a list of all the approved logins' do
      %w(u1 u2 u3).each { |u| GithubUser.add_approved!(u) }
      GithubUser.unapprove!('u3')

      expect(GithubUser.all_approved).to match_array(%w(u1 u2))
    end
  end

  describe '.add_admin!' do
    it 'creates an admin with the given login' do
      expect(GithubUser.find_by_login('somebody')).to be_nil
      GithubUser.add_admin!('somebody')
      expect(GithubUser.find_by_login('somebody')).to be_admin
    end

    it 'sets the user to admin if the user already exists' do
      GithubUser.create!(login: 'somebody')
      GithubUser.add_admin!('somebody')
      expect(GithubUser.find_by_login('somebody')).to be_admin
    end
  end

  describe '.remove_admin!' do
    it 'deletes an admin with the given login' do
      GithubUser.add_admin!('somebody')
      expect(GithubUser.find_by_login('somebody')).not_to be_nil
      GithubUser.remove_admin!('somebody')
      expect(GithubUser.find_by_login('somebody')).not_to be_admin
    end
  end

  describe '.all_admins' do
    it 'returns a list of all the admin logins' do
      %w(u1 u2 u3).each { |u| GithubUser.add_admin!(u) }
      GithubUser.remove_admin!('u3')

      expect(GithubUser.all_admins).to match_array(%w(u1 u2))
    end
  end
end
