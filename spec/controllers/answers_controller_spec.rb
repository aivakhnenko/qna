require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'valid attributes' do
      before { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }

      it 'saves a new Answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'saves answer with attributes from params in the database' do
        expect(attributes_for(:answer).to_a - assigns(:answer).attributes.symbolize_keys.to_a).to be_empty
      end

      it 'relates saved answer to question from params' do
        expect(assigns(:answer).question).to eq question
      end

      it 'relates saved answer to user' do
        expect(assigns(:answer).user).to eq subject.current_user
      end

      it 'redirects to question show' do
        expect(response).to redirect_to(question)
      end
    end

    context 'invalid attributes' do
      it 'does not save a new Answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }.not_to change(Answer, :count)
      end

      it 're-render question show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }

        expect(response).to render_template('questions/show')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:users) { create_list(:user, 2) }

    let!(:question) { create(:question, user: users[0]) }
    let!(:answer) { create(:answer, question: question, user: users[0]) }

    context 'user is answer author' do
      before { login(users[0]) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect_to question page' do
        delete :destroy, params: { question_id: question.id, id: answer }

        expect(response).to redirect_to question_path(question)
      end
    end

    context 'user is not answer author' do
      before { login(users[1]) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer } }.not_to change(Answer, :count)
      end

      it 'redirect_to question page' do
        delete :destroy, params: { question_id: question.id, id: answer }

        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
