require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET #github' do
    let(:oauth_data) { { 'provider' => 'github', 'uid' => 123 } }
    let(:service) { double('Services::FindForOauth') }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(Services::FindForOauth).to receive(:new).with(oauth_data).and_return(service)
      expect(service).to receive(:call)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(Services::FindForOauth).to receive(:new).and_return(service)
        allow(service).to receive(:call).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end
      
      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(Services::FindForOauth).to receive(:new).and_return(service)
        allow(service).to receive(:call)
        get :github
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET #facebook' do
    let(:oauth_data) { { 'provider' => 'facebook', 'uid' => 123 } }
    let(:service) { double('Services::FindForOauth') }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(Services::FindForOauth).to receive(:new).with(oauth_data).and_return(service)
      expect(service).to receive(:call)
      get :facebook
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(Services::FindForOauth).to receive(:new).and_return(service)
        allow(service).to receive(:call).and_return(user)
        get :facebook
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end
      
      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      let!(:user) { create(:user, :omniauth_tmp) }

      before do
        allow(Services::FindForOauth).to receive(:new).and_return(service)
        allow(service).to receive(:call).and_return(user)
        get :facebook
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end

      it 'renders change email page' do
        expect(response).to render_template 'devise/registrations/edit_email'
      end
    end
  end
end
