require 'rails_helper'

feature 'User can post answer', %q{
  In order to give the answer for the question
  As a user
  I'd like to be able to post the answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
      click_on 'Post answer'
    end

    scenario 'posts an answer' do
      fill_in 'Body', with: 'answer answer answer'
      click_on 'Post'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'answer answer answer'
    end

    scenario 'tries to post an answer with errors' do
      click_on 'Post'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries post an answer' do
    visit question_path(question)
    click_on 'Post answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
