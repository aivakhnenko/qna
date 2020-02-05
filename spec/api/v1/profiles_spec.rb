require 'rails_helper'

describe 'Profiles API', type: :request do
  PUBLIC_FIELDS = %w[id email admin created_at updated_at].freeze
  PRIVATE_FIELDS = %w[password password_confirmation].freeze

  let(:user) { create(:user) }
  let(:token) { create(:access_token, resource_owner_id: user.id).token }

  let(:public_fields) { %w[id email admin created_at updated_at] }

  describe 'GET /api/v1/profiles/me' do
    let(:method) { :get }
    let(:path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:user) { create(:user) }

      before { do_request method, path, params: { access_token: token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      PUBLIC_FIELDS.each do |attr|
        it "returns public field #{attr}" do
          expect(json['user'][attr]).to eq user.send(attr).as_json
        end
      end

      PRIVATE_FIELDS.each do |attr|
        it "does not return private field #{attr}" do
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:method) { :get }
    let(:path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:other_users) { create_list(:user, 3) }

      before { do_request method, path, params: { access_token: token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of other users' do
        expect(json['users'].count).to eq other_users.count
      end

      PUBLIC_FIELDS.each do |attr|
        it "returns public field #{attr}" do
          expect(json['users'].first[attr]).to eq other_users.first.send(attr).as_json
        end
      end

      PRIVATE_FIELDS.each do |attr|
        it "does not return private field #{attr}" do
          expect(json['users'].first).to_not have_key(attr)
        end
      end
    end
  end
end
