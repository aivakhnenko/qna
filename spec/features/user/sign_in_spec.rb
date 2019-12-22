require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unathenticated user
  I'd like to be able to sign in
} do

  background { visit new_user_session_path }

  describe 'Registered user' do
    given(:user) { create(:user) }

    scenario 'tries to sign in' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
      expect(page).to have_content 'Signed in successfully.'
    end

    describe 'tries to sign in using GitHub accound' do
      scenario 'using existed GitHub accound' do
        mock_auth_hash
        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario 'using non-existed GitHub accound' do
        OmniAuth.config.mock_auth[:github] = :invalid_credentials

        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials"'
      end
    end
  end

  describe 'Unregistered user' do
    scenario 'tries to sign in' do
      fill_in 'Email', with: 'wrong@test.com'
      fill_in 'Password', with: '12345678'
      click_on 'Log in'
      expect(page).to have_content 'Invalid Email or password.'
    end

    describe 'tries to sign in using GitHub accound' do
      scenario 'using existed GitHub accound' do
        mock_auth_hash
        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario 'using non-existed GitHub accound' do
        OmniAuth.config.mock_auth[:github] = :invalid_credentials
        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials"'
      end
    end
  end
end
