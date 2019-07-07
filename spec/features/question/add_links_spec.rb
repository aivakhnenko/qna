require "rails_helper.rb"

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:url) { 'https://www.google.com/' }
  given(:url2) { 'https://yandex.ru/' }
  given(:gist_url) { 'https://gist.github.com/aivakhnenko/d36c13e4c5b695b59257e54c757156aa' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'My link', href: url
  end

  scenario 'User adds many link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: url

    click_on 'add link'

    within '#links .nested-fields:nth-of-type(2)' do
      fill_in 'Link name', with: 'My link 2'
      fill_in 'Url', with: url2
    end

    click_on 'Ask'

    expect(page).to have_link 'My link', href: url
    expect(page).to have_link 'My link 2', href: url2
  end

  scenario 'User adds incorrect link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: 'url'

    click_on 'Ask'

    expect(page).to have_content "Links url is invalid"
  end

  scenario 'User add gist link', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    # sleep(10)

    # expect(page).to have_content 'CREATE DATABASE test_guru;'
  end
end
