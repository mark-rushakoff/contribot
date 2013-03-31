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
end
