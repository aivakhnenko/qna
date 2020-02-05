require "rails_helper.rb"

feature 'User can delete links from his answer', %q{
  In order to correct additional info to my answer
  As a answer's author
  I'd like to be able to delete links from my answer
} do

  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, user: users[0]) }
  given!(:answer) { create(:answer, question: question, user: users[0]) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'User removes link from his answer', js: true do
    sign_in(users[0])

    visit question_path(question)

    within '.answers .links-list' do
      click_on 'Delete link'

      expect(page).to_not have_link 'My link', href: 'https://www.google.com'
    end
  end

  scenario "User tries to delete other user's answer", js: true do
    sign_in(users[1])

    visit question_path(question)

    expect(page).to have_no_link 'Delete link'
  end

  scenario "Unauthenticated user tries to delete links from other user's answer", js: true do
    visit question_path(question)

    expect(page).to have_no_link 'Delete link'
  end
end
