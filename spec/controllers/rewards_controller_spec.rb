require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  describe 'GET #index' do
    let!(:users) { create_list(:user, 2) }
    let!(:question) { create_list(:question, 2, user: users[0]) }
    let!(:image1) { Rack::Test::UploadedFile.new(Rails.root.join('public', 'apple-touch-icon.png'), 'image/png') }
    let!(:reward0) { create(:reward, name: 'RewardName0', question: question[0]) }
    let!(:reward1) { create(:reward, name: 'RewardName1', question: question[1], image: image1) }
    let!(:answer00) { create(:answer, user: users[0], question: question[0]) }
    let!(:answer01) { create(:answer, user: users[0], question: question[1]) }
    let!(:answer10) { create(:answer, user: users[1], question: question[0]) }
    let!(:answer11) { create(:answer, user: users[1], question: question[1]) }

    before do
      answer00.best!
      answer11.best!
    end

    before { login(users[0]) }

    before { get :index }

    it 'assigns all Rewards user got to @rewards' do
      expect(assigns(:rewards)).to match_array([reward0])
    end

    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end
end
