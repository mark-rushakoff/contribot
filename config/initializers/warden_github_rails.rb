Warden::GitHub::Rails.setup do |config|
  config.add_scope :user,
    :client_id => ENV['CONTRIBOT_GITHUB_CLIENT_ID'],
    :client_secret => ENV['CONTRIBOT_GITHUB_CLIENT_SECRET'],
    :redirect_uri => '/login',
    :scope => ''
end
