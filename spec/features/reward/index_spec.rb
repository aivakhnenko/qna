require 'rails_helper'

feature 'User can see list of all rewards he got', %q{
  In order to see all rewards that I got
  As a user
  I'd like to be able to see list of all rewards I got
} do

  given!(:users) { create_list(:user, 2) }
  given!(:question) { create_list(:question, 2, user: users[0]) }
  given!(:image1) { Rack::Test::UploadedFile.new(Rails.root.join('public', 'apple-touch-icon.png'), 'image/png') }
  given!(:reward0) { create(:reward, name: 'RewardName0', question: question[0]) }
  given!(:reward1) { create(:reward, name: 'RewardName1', question: question[1], image: image1) }
  given!(:answer00) { create(:answer, user: users[0], question: question[0]) }
  given!(:answer01) { create(:answer, user: users[0], question: question[1]) }
  given!(:answer10) { create(:answer, user: users[1], question: question[0]) }
  given!(:answer11) { create(:answer, user: users[1], question: question[1]) }

  scenario 'User views list of all rewards he got' do
    answer00.best!
    answer11.best!

    sign_in(users[0])

    visit rewards_path

    expect(page).to have_content question[0].title
    expect(page).to_not have_content question[1].title
    expect(page).to have_content reward0.name
    expect(page).to_not have_content reward1.name
    expect(page).to have_css("img[src$='#{reward0.image.filename}']")
    expect(page).to_not have_css("img[src$='#{reward1.image.filename}']")
  end
end
