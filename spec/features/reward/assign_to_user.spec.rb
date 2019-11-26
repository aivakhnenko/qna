require 'rails_helper'

feature 'User can see reward for his answer, that was choosen as the best one', %q{
  In order to get reward for the best answer for question with reward
  As a best answer author
  I'd like to be able to see reward for my answer, that was selected as the best one
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:reward) { create(:reward, question: question) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'User sees reward for answer that was selected as the best one', js: true do
    sign_in(user)

    visit question_path(question)

    click_on 'Best answer'

    visit rewards_path

    expect(page).to have_content question.title
    expect(page).to have_content reward.name
    expect(page).to have_css("img[src$='#{reward.image.filename}']")
  end
end
