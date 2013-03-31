require 'spec_helper'

describe ApprovedUsersController do
  describe 'GET #index' do
    it 'assigns approved users and admins' do
      Fabricate(:github_user, login: 'u1', approved: true)
      Fabricate(:github_user, login: 'u2', approved: false)
      Fabricate(:github_user, login: 'u3', admin: true)
      get :index

      assigns(:approved_users).should eq('u1' => 'https://github.com/u1', 'u3' => 'https://github.com/u3')
    end
  end
end
