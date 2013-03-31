require 'spec_helper'

feature 'approved users' do
  scenario 'lists all of the approved users' do
    Fabricate(:github_user, login: 'user1', approved: true)
    Fabricate(:github_user, login: 'user2', approved: false)
    Fabricate(:github_user, login: 'user3', approved: true)

    visit approved_users_url

    expect(page).to have_link('user1', href: 'https://github.com/user1')
    expect(page).not_to have_link('https://github.com/user2')
    expect(page).to have_link('user3', href: 'https://github.com/user3')
  end
end
