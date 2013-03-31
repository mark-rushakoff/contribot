class AdminGithubUser < ActiveRecord::Base
  attr_accessible :login

  validates :login, uniqueness: true

  class << self
    def is_admin?(github_user)
      where(login: github_user.login).exists?
    end

    def add_admin!(login)
      create!(login: login)
    end

    def remove_admin!(login)
      destroy_all(login: login)
    end

    def all_admins
      pluck(:login)
    end
  end
end
