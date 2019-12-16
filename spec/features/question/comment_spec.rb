require 'rails_helper'

feature "User can post comments for question", %q{
  In order to leave comments for question
  As a user
  I'd like to be able to post comments for question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'comments question', js: true do
      fill_in 'Comment', with: 'Test comment'
      click_on 'Post comment'

      expect(page).to have_content 'Test comment'
    end

    scenario 'comments question multiple times', js: true do
      fill_in 'Comment', with: 'Test comment1'
      click_on 'Post comment'
      fill_in 'Comment', with: 'Test comment2'
      click_on 'Post comment'

      expect(page).to have_content 'Test comment1'
      expect(page).to have_content 'Test comment2'
    end
  end

  describe 'Within multiple sessions' do
    scenario 'user comments question in one session, other user sees it in another one', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Comment', with: 'Test comment'
        click_on 'Post comment'

        expect(page).to have_content 'Test comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test comment'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'cannot comment question', js: true do
      visit question_path(question)

      expect(page).to_not have_button 'Post comment'
    end
  end
end
