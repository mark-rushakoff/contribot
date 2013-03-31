class GithubUser < ActiveRecord::Base
  attr_accessible :login

  validates :login, uniqueness: true

  default_scope order('login ASC')

  class << self
    def add_approved!(login)
      user = find_or_create_by_login(login)
      user.approved = true
      user.save!
    end

    def unapprove!(login)
      user = find_by_login(login)
      return if user.nil?
      user.approved = false
      user.save!
    end

    def all_approved
      where(approved: true).pluck(:login)
    end

    def add_admin!(login)
      user = find_or_create_by_login(login)
      user.admin = true
      user.save!
    end

    def remove_admin!(login)
      user = find_by_login(login)
      return if user.nil?
      user.admin = false
      user.save!
    end

    def all_admins
      where(admin: true).pluck(:login)
    end

    def all_approved_and_admin
      # http://stackoverflow.com/a/13754977
      all = arel_table
      where(all[:admin].eq(true).or(all[:approved].eq(true))).pluck(:login)
    end
  end
end
