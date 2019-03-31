require 'rails_helper'

feature 'User can see list of all answers for question', %q{
  In order to find an answer for my problem
  As a user
  I'd like to be able to see list of all answers for question
} do

  scenario 'User views list of all answers for question' do
    question = create(:question)
    answers = create_list(:answer, 3, :list, question: question)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content question.answers[0].body
    expect(page).to have_content question.answers[1].body
    expect(page).to have_content question.answers[2].body
  end
end
