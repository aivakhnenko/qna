require "rails_helper.rb"

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:url) { 'https://www.google.com/' }
  given(:url2) { 'https://yandex.ru/' }

  scenario 'User adds link when posts answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: url

    click_on 'Post answer'

    within '.answers' do
      expect(page).to have_link 'My link', href: url
    end
  end

  scenario 'User adds many link when posts answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: url

    click_on 'add link'

    within '#links .nested-fields:nth-of-type(2)' do
      fill_in 'Link name', with: 'My link 2'
      fill_in 'Url', with: url2
    end

    click_on 'Post answer'

    within '.answers' do
      expect(page).to have_link 'My link', href: url
      expect(page).to have_link 'My link ', href: url2
    end
  end
end
