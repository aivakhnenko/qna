require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      context 'not subscribed yet' do
        it 'create subscription' do
          expect { post :create, params: { question_id: question.id } }.to change(Subscription, :count).by(1)
        end

        it 'redirects to question show page' do
          post :create, params: { question_id: question.id }

          expect(response).to redirect_to question
        end
      end

      context 'already subscribed' do
        let!(:subscription) { create(:subscription, user: user, question: question) }

        it 'not create subscription' do
          expect { post :create, params: { question_id: question.id } }.to_not change(Subscription, :count)
        end

        it 'redirects to question show page' do
          post :create, params: { question_id: question.id }

          expect(response).to redirect_to question
        end
      end
    end

    context 'unauthenticated user' do
      it 'not create subscription' do
        expect { post :create, params: { question_id: question.id } }.to_not change(Subscription, :count)
      end

      it 'redirects to login page' do
        post :create, params: { question_id: question.id }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, user: user, question: question) }

    context 'authenticated user' do
      before { login(user) }

      it 'delete subscription' do
        expect { delete :destroy, params: { id: subscription.id } }.to change(Subscription, :count).by(-1)
      end

      it 'redirects to question show page' do
        delete :destroy, params: { id: subscription.id }

        expect(response).to redirect_to question
      end
    end

    context 'unauthenticated user' do
      it 'not delete subscription' do
        expect { delete :destroy, params: { id: subscription.id } }.to_not change(Subscription, :count)
      end

      it 'redirects to login page' do
        delete :destroy, params: { id: subscription.id }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
