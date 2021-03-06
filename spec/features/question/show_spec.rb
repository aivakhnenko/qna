require 'rails_helper'

feature 'User can see list of all answers for question', %q{
  In order to find an answer for my problem
  As a user
  I'd like to be able to see list of all answers for question
} do

  given(:user) { create(:user) }

  scenario 'User views list of all answers for question' do
    question = create(:question, user: user)
    answers = create_list(:answer, 3, question: question, user: user)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each { |answer| expect(page).to have_content answer.body }
  end
end
