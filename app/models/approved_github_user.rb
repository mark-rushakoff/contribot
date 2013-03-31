class ApprovedGithubUser < ActiveRecord::Base
  attr_accessible :login

  validates :login, uniqueness: true

  class << self
    def is_approved?(github_user)
      where(login: github_user.login).exists?
    end

    def add_approved!(login)
      create!(login: login)
    end

    def remove_approved!(login)
      destroy_all(login: login)
    end

    def all_approved
      pluck(:login)
    end
  end
end
