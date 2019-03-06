require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #new' do
    before do
      @question = create(:question)
      get :new, params: { question_id: @question.id }
    end
    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'relates @answer to question from params' do
      expect(assigns(:answer).question).to eq @question
    end
    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    before do
      @count = Answer.count
      @question = create(:question)
    end
    context 'valid attributes' do
      before { post :create, params: { question_id: @question.id, answer: attributes_for(:answer) } }
      it 'saves a new Answer in the database' do
        expect(Answer.count).to eq @count + 1
      end
      it 'saves answer with attributes from params in the database' do
        expect(attributes_for(:answer).to_a - Answer.last.attributes.symbolize_keys.to_a).to be_empty
      end
      it 'relates saved answer to question from params' do
        expect(Answer.last.question).to eq @question
      end
      it 'redirects to show view for newly created answer' do
        expect(response).to redirect_to([@question, assigns(:answer)])
      end
    end
    context 'invalid attributes' do
      before { post :create, params: { question_id: @question.id, answer: attributes_for(:answer, :invalid) } }
      it 'does not save a new Answer in the database' do
        expect(Answer.count).to eq @count
      end
      it 're-render new view' do
        expect(response).to render_template(:new)
      end
    end
  end
end
