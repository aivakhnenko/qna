require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unregistered user
  I'd like to be able to sign up
} do

  scenario 'Unregistered user tries to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sign up with errors' do
    visit new_user_registration_path
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end
