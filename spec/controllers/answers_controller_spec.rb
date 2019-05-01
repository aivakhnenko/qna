require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'valid attributes' do
      let(:answer_attributes) { attributes_for(:answer) }

      before { post :create, params: { question_id: question.id, answer: answer_attributes }, format: :js }

      it 'saves a new Answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: answer_attributes }, format: :js }.to change(Answer, :count).by(1)
      end

      it 'saves answer with attributes from params in the database' do
        expect(answer_attributes.to_a - assigns(:answer).attributes.symbolize_keys.to_a).to be_empty
      end

      it 'relates saved answer to question from params' do
        expect(assigns(:answer).question).to eq question
      end

      it 'relates saved answer to user' do
        expect(assigns(:answer).user).to eq subject.current_user
      end

      it 'redirects to question show' do
        expect(response).to render_template('create')
      end
    end

    context 'invalid attributes' do
      it 'does not save a new Answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js }.not_to change(Answer, :count)
      end

      it 're-render question show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template('create')
      end
    end
  end

  describe 'PATCH #update' do
    let(:users) { create_list(:user, 2) }

    let!(:question) { create(:question, user: users[0]) }
    let!(:answer) { create(:answer, question: question, user: users[0]) }

    context 'user is answer author' do
      before { login(users[0]) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'user is not answer author' do
      before { login(users[1]) }
      let!(:body) { answer.body }

      it 'does not update the answer' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload

        expect(answer.body).to eq body
      end

      it 'redirect_to question page' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js

        expect(response).to redirect_to question_path(question)
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
        expect { delete :destroy, params: { question_id: question.id, id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirect_to question page' do
        delete :destroy, params: { question_id: question.id, id: answer }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'user is not answer author' do
      before { login(users[1]) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer }, format: :js }.not_to change(Answer, :count)
      end

      it 'redirect_to question page' do
        delete :destroy, params: { question_id: question.id, id: answer }, format: :js

        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH #best' do
    let(:users) { create_list(:user, 2) }
    let!(:question) { create(:question, user: users[0]) }
    let!(:answers) { create_list(:answer, 2, question: question, user: users[0]) }

    context 'user is the author of question' do
      before { login(users[0]) }

      context 'there was not the best answer' do
        it 'sets best answer for question' do
          patch :best, params: { answer_id: answers[0] }, format: :js
          expect(answers[0].reload.best).to be_truthy
        end

        it 'renders best view' do
          patch :best, params: { answer_id: answers[0] }, format: :js
          expect(response).to render_template :best
        end
      end

      context 'there was the best answer' do
        before { answers[1].best! }

        it 'unsets previous best answer for question' do
          patch :best, params: { answer_id: answers[0] }, format: :js
          expect(answers[1].reload.best).to be_falsey
        end

        it 'sets new best answer for question' do
          patch :best, params: { answer_id: answers[0] }, format: :js
          expect(answers[0].reload.best).to be_truthy
        end

        it 'renders best view' do
          patch :best, params: { answer_id: answers[0] }, format: :js
          expect(response).to render_template :best
        end
      end
    end

    context 'user is not the author of question' do
      it 'redirect_to question page' do
        login(users[1])

        patch :best, params: { answer_id: answers[0] }, format: :js
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
