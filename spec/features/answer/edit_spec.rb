require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of the answer
  I'd like to be able to edit my answer
} do

  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users[0]) }
  given!(:answer) { create(:answer, question: question, user: users[0]) }

  describe 'Authenticated user' do
    describe 'edits his answer' do
      background do
        sign_in(users[0])

        visit question_path(question)

        click_on 'Edit'
      end

      scenario 'without errors', js: true do
        within '.answers' do
          fill_in 'Your answer:', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'with errors', js: true do
        within '.answers' do
          fill_in 'Your answer:', with: ''
          click_on 'Save'
        end

        expect(page).to have_content "Answer can't be blank"
      end
    end

    scenario "can not edit other user's answer", js: true do
      sign_in(users[1])

      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthenticated user can not edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
