require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: question.id } }

    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'relates @answer to question from params' do
      expect(assigns(:answer).question).to eq question
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

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

      it 'redirects to show view for newly created answer' do
        expect(response).to redirect_to([question, assigns(:answer)])
      end
    end

    context 'invalid attributes' do
      before { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }

      it 'does not save a new Answer in the database' do
        expect(Answer.count).to eq count
      end

      it 're-render new view' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #show' do
    let(:answer) { create(:answer, question: question) }
    
    before { get :show, params: { question_id: question.id, id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end
end
