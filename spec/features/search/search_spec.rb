require 'sphinx_helper'

feature 'User can search for resources', %q{
  In order to find needed resources
  As a User
  I'd like to be able to search for the resources
} do

  background do
    visit root_path
  end

  describe 'Search questions' do
    given!(:q1) { create(:question, title: 'title one with tag') }
    given!(:q2) { create(:question, title: 'title two') }
    given!(:q3) { create(:question, body: 'body one with tag') }
    given!(:q4) { create(:question, body: 'body two') }

    scenario 'there is result', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '.search_form' do
          select 'Questions', from: :t
          fill_in :q, with: 'tag'
          click_on 'Search'
        end

        expect(page).to have_content q1.title
        expect(page).to_not have_content q2.title
        expect(page).to have_content q3.title
        expect(page).to_not have_content q4.title
      end
    end

    scenario 'there is no result', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '.search_form' do
          select 'Questions', from: :t
          fill_in :q, with: 'something'
          click_on 'Search'
        end

        expect(page).to have_content 'No results'
      end
    end
  end

  describe 'Search answers' do
    given!(:a1) { create(:answer, body: 'body one with tag') }
    given!(:a2) { create(:answer, body: 'body two') }

    scenario 'there is result', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '.search_form' do
          select 'Answers', from: :t
          fill_in :q, with: 'tag'
          click_on 'Search'
        end

        expect(page).to have_content a1.body
        expect(page).to_not have_content a2.body
      end
    end

    scenario 'there is no result', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '.search_form' do
          select 'Answers', from: :t
          fill_in :q, with: 'something'
          click_on 'Search'
        end

        expect(page).to have_content 'No results'
      end
    end
  end

  describe 'Search comments' do
    given!(:c1) { create(:comment, text: 'text one with tag') }
    given!(:c2) { create(:comment, text: 'text two') }

    scenario 'there is result', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '.search_form' do
          select 'Comments', from: :t
          fill_in :q, with: 'tag'
          click_on 'Search'
        end

        expect(page).to have_content c1.text
        expect(page).to_not have_content c2.text
      end
    end

    scenario 'there is no result', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '.search_form' do
          select 'Comments', from: :t
          fill_in :q, with: 'something'
          click_on 'Search'
        end

        expect(page).to have_content 'No results'
      end
    end
  end

  describe 'Search users' do
    given!(:u1) { create(:user, email: 'tag.user@test.com') }
    given!(:u2) { create(:user, email: 'other.user@test.com') }

    scenario 'there is result', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '.search_form' do
          select 'Users', from: :t
          fill_in :q, with: 'tag'
          click_on 'Search'
        end

        expect(page).to have_content u1.email
        expect(page).to_not have_content u2.email
      end
    end

    scenario 'there is no result', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '.search_form' do
          select 'Users', from: :t
          fill_in :q, with: 'something'
          click_on 'Search'
        end

        expect(page).to have_content 'No results'
      end
    end
  end

  describe 'Search all' do
    given!(:q1) { create(:question, title: 'title one with tag') }
    given!(:q2) { create(:question, title: 'title two') }
    given!(:a1) { create(:answer, body: 'body one with tag') }
    given!(:a2) { create(:answer, body: 'body two') }
    given!(:c1) { create(:comment, text: 'text one with tag') }
    given!(:c2) { create(:comment, text: 'text two') }
    given!(:u1) { create(:user, email: 'tag.user@test.com') }
    given!(:u2) { create(:user, email: 'other.user@test.com') }

    scenario 'there is result', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '.search_form' do
          select 'All', from: :t
          fill_in :q, with: 'tag'
          click_on 'Search'
        end

        expect(page).to have_content q1.title
        expect(page).to_not have_content q2.title
        expect(page).to have_content a1.body
        expect(page).to_not have_content a2.body
        expect(page).to have_content c1.text
        expect(page).to_not have_content c2.text
        expect(page).to have_content u1.email
        expect(page).to_not have_content u2.email
      end
    end

    scenario 'there is no result', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '.search_form' do
          select 'All', from: :t
          fill_in :q, with: 'something'
          click_on 'Search'
        end

        expect(page).to have_content 'No results'
      end
    end
  end
end
