require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    let!(:count) { Answer.count }

    context 'valid attributes' do
      before { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }

      it 'saves a new Answer in the database' do
        expect(Answer.count).to eq count + 1
      end

      it 'saves answer with attributes from params in the database' do
        expect(attributes_for(:answer).to_a - Answer.last.attributes.symbolize_keys.to_a).to be_empty
      end

      it 'relates saved answer to question from params' do
        expect(Answer.last.question).to eq question
      end

      it 'redirects to question show' do
        expect(response).to redirect_to(question)
      end
    end

    context 'invalid attributes' do
      before { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }

      it 'does not save a new Answer in the database' do
        expect(Answer.count).to eq count
      end

      it 're-render question show view' do
        expect(response).to render_template('questions/show')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:users) { create_list(:user, 2) }

    let!(:question) { create(:question, user: users[0]) }
    let!(:answer) { create(:answer, question: question, user: users[0]) }
    let!(:count) { Answer.count }

    context 'user is answer author' do
      before { login(users[0]) }
      before { delete :destroy, params: { question_id: question.id, id: answer } }

      it 'deletes the answer' do
        expect(Answer.count).to eq count - 1
      end

      it 'redirect_to question page' do
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'user is not answer author' do
      before { login(users[1]) }
      before { delete :destroy, params: { question_id: question.id, id: answer } }

      it 'does not delete the answer' do
        expect(Answer.count).to eq count
      end

      it 'redirect_to question page' do
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
