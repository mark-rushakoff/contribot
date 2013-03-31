class ApprovedUsersController < ApplicationController
  def index
    @approved_users = {}
    GithubUser.all_approved_and_admin.each do |login|
      @approved_users[login] = "https://github.com/#{login}"
    end
  end
end
