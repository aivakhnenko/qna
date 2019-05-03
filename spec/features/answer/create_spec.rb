require 'rails_helper'

feature 'User can post answer', %q{
  In order to give the answer for the question
  As a user
  I'd like to be able to post the answer
} do
  
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'posts an answer', js: true do
      fill_in 'Your answer', with: 'answer answer answer'
      click_on 'Post answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'answer answer answer'
    end

    scenario 'tries to post an answer with errors', js: true do
      click_on 'Post answer'

      expect(page).to have_content "Answer can't be blank"
    end

    scenario 'posts an answer with attached files', js: true do
      fill_in 'Your answer', with: 'answer answer answer'
      attach_file 'Files', [Rails.root.join('spec', 'rails_helper.rb'), Rails.root.join('spec', 'spec_helper.rb')]
      click_on 'Post answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user can not post an answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Post answer'
  end
end
