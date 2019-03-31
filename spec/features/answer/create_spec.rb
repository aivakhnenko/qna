require 'rails_helper'

feature 'User can post answer', %q{
  In order to give the answer for the question
  As a user
  I'd like to be able to post the answer
} do

  scenario 'User posts an answer' do
    question = create(:question)

    visit question_path(question)
    click_on 'Post answer'

    fill_in 'Body', with: 'answer answer answer'
    click_on 'Post'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'answer answer answer'
  end

  scenario 'User tries to post an answer with errors' do
    question = create(:question)

    visit question_path(question)
    click_on 'Post answer'

    click_on 'Post'

    expect(page).to have_content "Body can't be blank"
  end
end
