require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of the answer
  I'd like to be able to edit my answer
} do

  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users[0]) }
  given!(:answer) { create(:answer, :with_file_attached, question: question, user: users[0]) }
  given!(:link) { create(:link, linkable: answer) }

  describe 'Authenticated user' do
    describe 'edits his answer' do
      background do
        sign_in(users[0])

        visit question_path(question)

        click_on 'Edit'
      end

      scenario 'without errors', js: true do
        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'with errors', js: true do
        within '.answers' do
          fill_in 'Your answer', with: ''
          click_on 'Save'
        end

        expect(page).to have_content "Answer can't be blank"
      end

      scenario 'with attaching new file', js: true do
        within '.answers' do
          expect(page).to have_selector 'input[type=file]'
          attach_file 'Files', Rails.root.join('spec', 'spec_helper.rb')
          click_on 'Save'

          expect(page).to have_link 'spec_helper.rb'
          expect(page).to_not have_selector 'input[type=file]'
        end
      end

      scenario 'with removing attached file', js: true do
        within '.answers' do
          click_on 'Remove file'

          expect(page).to_not have_link 'rails_helper.rb'
        end
      end

      scenario 'with adding new link', js: true do
        within '.answers' do
          click_on 'add link'

          within '#links .nested-fields:nth-of-type(2)' do
            fill_in 'Link name', with: 'My link 2'
            fill_in 'Url', with: 'https://yandex.ru'
          end

          click_on 'Save'

          expect(page).to have_link 'My link', href: 'https://www.google.com'
          expect(page).to have_link 'My link 2', href: 'https://yandex.ru'
        end
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
