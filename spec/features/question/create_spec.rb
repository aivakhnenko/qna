require 'rails_helper'

feature 'User can create question', %q{
  In order to get an answer from a community
  As a user
  I'd like to be able to ask the question
} do

  background do
    visit questions_path
    click_on 'Ask question'
  end

  scenario 'User asks a question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text text'
  end

  scenario 'User asks a question with errors' do
    click_on 'Ask'

    expect(page).to have_content "Title can't be blank"
  end
end
