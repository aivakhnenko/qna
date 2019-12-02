require 'rails_helper'

feature "User can vote for other user's question", %q{
  In order to vote for/against question
  As a user
  I'd like to be able to vote for/against question
} do

  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users[1]) }

  describe 'Authenticated user' do
    describe "votes for other user's question" do
      background do
        sign_in(users[0])

        visit question_path(question)
      end

      scenario '- votes for question', js: true do
        click_on 'Vote up'

        within '.votes' do
          expect(page).to have_content 'Voted up'
          expect(page).to_not have_content 'Voted down'
          expect(page).to_not have_link 'Vote up'
          expect(page).to have_link 'Vote down'
          expect(page).to have_content '1'
        end
      end

      scenario '- votes against question', js: true do
        click_on 'Vote down'

        within '.votes' do
          expect(page).to_not have_content 'Voted up'
          expect(page).to have_content 'Voted down'
          expect(page).to have_link 'Vote up'
          expect(page).to_not have_link 'Vote down'
          expect(page).to have_content '-1'
        end
      end

      scenario '- can cancel his vote', js: true do
        click_on 'Vote up'
        click_on 'Cancel vote'

        within '.votes' do
          expect(page).to_not have_content 'Voted up'
          expect(page).to_not have_content 'Voted down'
          expect(page).to have_link 'Vote up'
          expect(page).to have_link 'Vote down'
          expect(page).to have_content '0'
        end
      end

      scenario '- can change his vote', js: true do
        click_on 'Vote up'
        click_on 'Vote down'

        within '.votes' do
          expect(page).to_not have_content 'Voted up'
          expect(page).to have_content 'Voted down'
          expect(page).to have_link 'Vote up'
          expect(page).to_not have_link 'Vote down'
          expect(page).to have_content '-1'
        end
      end

      scenario '- cannot vote two same ways in a row', js: true do
        click_on 'Vote up'

        within '.votes' do
          expect(page).to_not have_link 'Vote up'
        end
      end
    end

    scenario 'can not vote for his own question', js: true do
      sign_in(users[1])

      visit question_path(question)

      expect(page).to_not have_link 'Vote up'
      expect(page).to_not have_link 'Vote down'
    end
  end

  scenario 'Unauthenticated user cannot vote', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Vote up'
    expect(page).to_not have_link 'Vote down'
  end
end
