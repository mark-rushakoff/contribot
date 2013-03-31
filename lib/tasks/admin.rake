namespace :admin do
  desc "Mark the given GitHub login as a site admin"
  task :add, [:login] => :environment do |t, args|
    login = args[:login]
    GithubUser.add_admin!(login)
    puts "Successfully marked #{login} as an admin"
  end

  desc "Remove the given GitHub login from site admins"
  task :remove, [:login] => :environment do |t, args|
    login = args[:login]
    GithubUser.remove_admin!(login)
    puts "Successfully removed #{login} from admins"
  end

  desc "List the GitHub logins that are marked as site admins"
  task :list => :environment do
    puts GithubUser.all_admins.join("\n")
  end
end
