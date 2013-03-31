class AdminGithubUser < ActiveRecord::Base
  attr_accessible :login

  validates :login, uniqueness: true

  def self.is_admin?(github_user)
    !!find_by_login(github_user.login)
  end
end
