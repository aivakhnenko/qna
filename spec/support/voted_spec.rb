require 'rails_helper'

shared_examples 'voted' do
  let(:model) { described_class.controller_name.singularize }

  describe 'POST #vote' do
    let(:users) { create_list(:user, 2) }
    let!(:resource) { create(model, user: users[1]) }

    context 'user is not resource author' do
      before { login(users[0]) }

      context 'there is no previous vote' do
        context 'vote up' do
          it 'saves vote up in the database' do
            expect { post :vote, params: { id: resource, value: 1 }, format: :json }.to change(Vote, :count).by(1)
          end

          it 'renders json of total votes sum and current user vote value' do
            post :vote, params: { id: resource, value: 1 }, format: :json
            expect(response.body).to eq ({ votes: 1, vote: 1 }).to_json
          end
        end

        context 'vote down' do
          it 'saves vote up in the database' do
            expect { post :vote, params: { id: resource.id, value: -1 }, format: :json }.to change(Vote, :count).by(1)
          end

          it 'renders json of total votes sum and current user vote value' do
            post :vote, params: { id: resource, value: -1 }, format: :json
            expect(response.body).to eq ({ votes: -1, vote: -1 }).to_json
          end
        end
      end

      context 'there is previous vote' do
        let!(:vote) { create(:vote, votable: resource, user: users[0], value: 1) }

        context 'cancel vote' do
          it 'remove vote from the database' do
            expect { post :vote, params: { id: resource, value: 0 }, format: :json }.to change(Vote, :count).by(-1)
          end

          it 'renders json of total votes sum and current user vote value' do
            post :vote, params: { id: resource, value: 0 }, format: :json
            expect(response.body).to eq ({ votes: 0, vote: 0 }).to_json
          end
        end

        context 'change vote' do
          it 'change vote in the database' do
            post :vote, params: { id: resource, value: -1 }, format: :json
            expect(Vote.last.value).to eq -1
          end

          it 'renders json of total votes sum and current user vote value' do
            post :vote, params: { id: resource, value: -1 }, format: :json
            expect(response.body).to eq ({ votes: -1, vote: -1 }).to_json
          end
        end

        context 'make the same vote' do
          it 'does not change votes in the database' do
            expect { post :vote, params: { id: resource, value: 1 }, format: :json }.to_not change(Vote, :count)
          end

          it 'renders json of total votes sum and current user vote value' do
            post :vote, params: { id: resource, value: 1 }, format: :json
            expect(response.body).to eq ({ votes: 1, vote: 1 }).to_json
          end
        end
      end
    end

    context 'user is resource author' do
      before { login(users[1]) }

      it 'does not create vote in the database' do
        expect { post :vote, params: { id: resource, value: 1 }, format: :json }.to_not change(Vote, :count)
      end

      it 'renders json of total votes sum and current user vote value' do
        post :vote, params: { id: resource, value: 1 }, format: :json
        expect(response.body).to eq ({ votes: 0, vote: 0 }).to_json
      end
    end
  end
end
