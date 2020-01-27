require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unathenticated user
  I'd like to be able to sign in
} do

  background { visit new_user_session_path }

  describe 'Sign in with Github (with email from provider)' do
    scenario 'using non-existed GitHub account' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials"'
    end

    describe 'using existed GitHub account' do
      describe 'with email of registered user' do
        let!(:user) { create(:user) }

        scenario 'sign in' do
          mock_auth_hash
          click_on 'Sign in with GitHub'
          expect(page).to have_content 'Successfully authenticated from Github account.'
        end
      end

      describe 'with email of unregistered user' do
        scenario 'sign in' do
          mock_auth_hash
          click_on 'Sign in with GitHub'
          expect(page).to have_content 'Successfully authenticated from Github account.'
        end
      end
    end
  end

  describe 'Sign in with Facebook (without email from provider)' do
    scenario 'using non-existed Facebook account' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Could not authenticate you from Facebook because "Invalid credentials"'
    end

    scenario 'using existed Facebook account' do
      clear_emails
      mock_auth_hash
      click_on 'Sign in with Facebook'

      fill_in 'Email', with: 'user@test.com'
      click_on 'Save email'

      open_email('user@test.com')
      current_email.click_link 'Confirm my account'

      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end
  end
end
