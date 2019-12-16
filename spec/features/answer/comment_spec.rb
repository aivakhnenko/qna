require 'rails_helper'

feature "User can post comments for answer", %q{
  In order to leave comments for answer
  As a user
  I'd like to be able to post comments for answer
} do

  given!(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'comments answer', js: true do
      within '.answers' do
        fill_in 'Comment', with: 'Test comment'
        click_on 'Post comment'

        expect(page).to have_content 'Test comment'
      end
    end

    scenario 'comments answer multiple times', js: true do
      within '.answers' do
        fill_in 'Comment', with: 'Test comment1'
        click_on 'Post comment'
        fill_in 'Comment', with: 'Test comment2'
        click_on 'Post comment'

        expect(page).to have_content 'Test comment1'
        expect(page).to have_content 'Test comment2'
      end
    end
  end

  describe 'Within multiple sessions' do
    scenario 'user comments answer in one session, other user sees it in another one', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          fill_in 'Comment', with: 'Test comment'
          click_on 'Post comment'

          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Test comment'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'cannot comment answer', js: true do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_button 'Post comment'
      end
    end
  end
end
