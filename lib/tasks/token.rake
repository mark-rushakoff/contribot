namespace :token do
  desc "Generate an OAuth2 token for the given username (you will be prompted for the password)"
  task :generate, [:username] => :environment do |t, args|
    username = args[:username]
    client = build_client(username)
    client.create_authorization(:scopes => %w(repo), :note => "contribot via rake token:generate")
    list_authorizations(client)
  end

  desc "List the OAuth2 tokens for the given username (you will be prompted for the password)"
  task :list, [:username] => :environment do |t, args|
    username = args[:username]
    client = build_client(username)
    list_authorizations(client)
  end

  def build_client(username)
    require 'io/console'
    puts "Enter the password for #{username} (input will be hidden until you hit enter)"
    Octokit::Client.new(login: username, password: $stdin.noecho(&:gets).chomp)
  end

  def list_authorizations(client)
    client.authorizations.each do |auth|
      puts "Token: #{auth.token}\nNote: #{auth.note}\n\n"
    end
  end
end
