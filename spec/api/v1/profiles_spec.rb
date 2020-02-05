require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:public_fields) { %w[id email admin created_at updated_at] }
  let(:private_fields) { %w[password password_confirmation] }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        public_fields.each do |attr|
          expect(json['user'][attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        private_fields.each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let!(:other_users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of other users' do
        expect(json['users'].size).to eq 3
      end

      it 'returns all public fields' do
        public_fields.each do |attr|
          expect(json['users'].first[attr]).to eq other_users.first.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        private_fields.each do |attr|
          expect(json['users'].first).to_not have_key(attr)
        end
      end
    end
  end
end
