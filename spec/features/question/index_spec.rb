require 'rails_helper'

feature 'User can see list of all questions', %q{
  In order to find an answer for my problem
  As a user
  I'd like to be able to see list of all questions
} do

  given(:user) { create(:user) }

  scenario 'User views list of all questions' do
    questions = create_list(:question, 3, :list, user: user)

    visit questions_path

    expect(page).to have_content 'Questions'
    questions.each { |question| expect(page).to have_link question.title, href: question_path(question) }
  end
end
