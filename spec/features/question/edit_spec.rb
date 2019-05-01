require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of the question
  I'd like to be able to edit my question
} do

  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users[0]) }

  describe 'Authenticated user' do
    describe 'edits his question' do
      background do
        sign_in(users[0])

        visit question_path(question)
        click_on 'Edit question'
      end

      scenario 'without errors', js: true do
        within '.question' do
          fill_in 'Body', with: 'edited question body'
          click_on 'Save question'

          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited question body'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'with errors', js: true do
        within '.question' do
          fill_in 'Body', with: ''
          click_on 'Save question'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "can not edit other user's question", js: true do
      sign_in(users[1])

      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end

  scenario 'Unauthenticated user can not edit question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end
end