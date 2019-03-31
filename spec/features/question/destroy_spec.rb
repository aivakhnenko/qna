require 'rails_helper'

feature 'User can delete his question', %q{
  In order to remove question and stop getting answers
  As a question author
  I'd like to be able to delete the question
} do

  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, user: users[0]) }

  scenario 'Author delete his question' do
    sign_in(users[0])

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Your question successfully deleted.'
  end

  scenario "User tries to delete other user's question" do
    sign_in(users[1])

    visit question_path(question)

    expect(page).to have_no_content 'Delete question'
  end
end
