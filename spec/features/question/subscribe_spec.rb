require 'rails_helper'

feature "User can subscribe to question", %q{
  To receive new answers
  As a user
  I'd like to be able to subscribe to question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'as an author are subscribed to question', js: true do
      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to_not have_content 'Subscribe'
      expect(page).to have_content 'Unsubscribe'
    end

    scenario 'can subscribe to question', js: true do
      expect(page).to have_content 'Subscribe'

      click_on 'Subscribe'

      expect(page).to_not have_content 'Subscribe'
      expect(page).to have_content 'Unsubscribe'
    end

    scenario 'can unsubscribe to question', js: true do
      click_on 'Subscribe'
      click_on 'Unsubscribe'

      expect(page).to have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'cannot subscribe to question', js: true do
      visit question_path(question)

      expect(page).to_not have_button 'Subscribe'
      expect(page).to_not have_button 'Unsubscribe'
    end
  end
end
