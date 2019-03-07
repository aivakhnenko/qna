require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'assigns all Questions to @questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let!(:count) { Question.count }

    context 'valid attributes' do
      before { post :create, params: { question: attributes_for(:question) } }

      it 'saves a new Question in the database' do
        expect(Question.count).to eq count + 1
      end

      it 'saves question with attributes from params in the database' do
        expect(attributes_for(:question).to_a - Question.last.attributes.symbolize_keys.to_a).to be_empty
      end

      it 'redirects to show view for newly created question' do
        expect(response).to redirect_to(assigns(:question))
      end
    end

    context 'invalid attributes' do
      before { post :create, params: { question: attributes_for(:question, :invalid) } }

      it 'does not save a new Question in the database' do
        expect(Question.count).to eq count
      end

      it 're-render new view' do
        expect(response).to render_template(:new)
      end
    end
  end
end
