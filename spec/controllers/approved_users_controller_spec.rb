require 'spec_helper'

describe ApprovedUsersController do
  describe 'GET #index' do
    it 'assigns approved_users' do
      Fabricate(:github_user, login: 'u1', approved: true)
      Fabricate(:github_user, login: 'u2', approved: false)
      get :index

      assigns(:approved_users).should eq('u1' => 'https://github.com/u1')
    end
  end
end
