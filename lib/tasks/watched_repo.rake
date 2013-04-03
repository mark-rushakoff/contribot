namespace :repo do
  desc "Watch the repo (given in form of 'owner/project') for pull requests"
  task :watch, [:owner_and_repo] => :environment do |t, args|
    include Rails.application.routes.url_helpers
    default_host = ENV['CONTRIBOT_HOST']
    raise "Must set ENV['CONTRIBOT_HOST']" if default_host.blank?
    default_url_options[:host] = default_host
    owner, repo_name = args[:owner_and_repo].split('/')
    WatchedRepo.watch_pull_requests!(owner, repo_name, root_url)
  end
end
