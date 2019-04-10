require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to remove his answer
  As an answer author
  I'd like to be able to delete his answer
} do

  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, user: users[0]) }
  given!(:answer) { create(:answer, question: question, user: users[0]) }

  scenario 'Author delete his answer' do
    sign_in(users[0])

    visit question_path(question)

    click_on 'Delete answer'

    expect(page).to have_content 'Your answer successfully deleted.'

    expect(page).to have_no_content answer.body
  end

  scenario "User tries to delete other user's answer" do
    sign_in(users[1])

    visit question_path(question)

    expect(page).to have_no_link 'Delete answer'
  end

  scenario "Unauthenticated user tries to delete other user's answer" do
    visit question_path(question)

    expect(page).to have_no_link 'Delete answer'
  end
end
