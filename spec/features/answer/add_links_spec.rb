require "rails_helper.rb"

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/aivakhnenko/d36c13e4c5b695b59257e54c757156aa' }

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Post answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
