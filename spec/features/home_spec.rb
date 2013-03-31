require 'spec_helper'

feature 'home page' do
  scenario 'includes a link to the approved users page' do
    visit root_url

    expect(page).to have_link('Approved users', approved_users_path)
  end
end
