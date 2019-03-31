require 'rails_helper'

feature 'User can see list of all questions', %q{
  In order to find an answer for my problem
  As a user
  I'd like to be able to see list of all questions
} do

  scenario 'User views list of all questions' do
    questions = create_list(:question, 3, :list)

    visit questions_path

    expect(page).to have_content 'Questions'
    expect(page).to have_link questions[0].title, href: question_path(questions[0])
    expect(page).to have_link questions[1].title, href: question_path(questions[1])
    expect(page).to have_link questions[2].title, href: question_path(questions[2])
  end
end
