require 'rails_helper'

feature 'User can choose best answer', %q{
  In order to choose the best answer for the question
  As a question author
  I'd like to be able to choose the best answer
} do
  
  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users[0]) }
  given!(:answers) { create_list(:answer, 2, question: question, user: users[0]) }

  scenario 'Author of the question select best answer', js: true do
    sign_in(users[0])

    visit question_path(question)

    within ".answer-#{answers[1].id}" do
      click_on 'Best answer'
    end

    wait_for_ajax

    expect(page.body).to match /answer-#{answers[1].id}.*answer-#{answers[0].id}/
  end

  describe 'Best answer already selected' do
    background { question.update(answer: answers[1]) }

    scenario 'Author of the question select other best answer', js: true do
      sign_in(users[0])

      visit question_path(question)

      within ".answer-#{answers[0].id}" do
        click_on 'Best answer'
      end

      wait_for_ajax

      expect(page.body).to match /answer-#{answers[0].id}.*answer-#{answers[1].id}/
    end

    scenario 'Best answer should be first in answers list', js: true do
      visit question_path(question)

      expect(page.body).to match /answer-#{answers[1].id}.*answer-#{answers[0].id}/
    end
  end

  scenario 'Not author of the question can not select best answer', js: true do
    sign_in(users[1])

    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end

  scenario 'Unauthenticated user can not select best answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end
end
