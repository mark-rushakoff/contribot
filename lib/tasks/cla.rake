namespace :cla do
  desc "Mark the given GitHub login as having completed the CLA"
  task :approve, [:login] => :environment do |t, args|
    login = args[:login]
    GithubUser.add_approved!(login)
    puts "Successfully marked #{login} as having completed the CLA"
  end

  desc "Unmark the given GitHub login as having completed the CLA"
  task :unapprove, [:login] => :environment do |t, args|
    login = args[:login]
    GithubUser.remove_approved!(login)
    puts "Successfully unmarked #{login} as having completed the CLA"
  end

  desc "List the GitHub logins that are marked as having completed the CLA"
  task :list => :environment do
    puts GithubUser.all_approved.join("\n")
  end
end
