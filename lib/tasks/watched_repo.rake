namespace :repo do
  desc "Watch the repo (given in form of 'owner/project') for pull requests"
  task :watch, [:owner_and_repo] => :environment do |t, args|
    include Rails.application.routes.url_helpers
    default_host = ENV['CONTRIBOT_HOST']
    raise "Must set ENV['CONTRIBOT_HOST']" if default_host.blank?
    default_url_options[:host] = default_host
    owner, repo_name = args[:owner_and_repo].split('/')
    WatchedRepo.watch_pull_requests!(owner, repo_name, pull_request_hook_url(owner: owner, repo_name: repo_name))
    puts "Now watching pull requests for #{args[:owner_and_repo]}"
  end

  desc "Stop watching the repo (given in form of 'owner/project') for pull requests"
  task :watch, [:owner_and_repo] => :environment do |t, args|
    include Rails.application.routes.url_helpers
    owner, repo_name = args[:owner_and_repo].split('/')
    WatchedRepo.stop_watching_pull_requests!(owner, repo_name)
    puts "Stopped watching pull requests for #{args[:owner_and_repo]}"
  end
end
