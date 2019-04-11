require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'assigns all Questions to @questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'valid attributes' do
      before { post :create, params: { question: attributes_for(:question) } }

      it 'saves a new Question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'saves question with attributes from params in the database' do
        expect(attributes_for(:question).to_a - assigns(:question).attributes.symbolize_keys.to_a).to be_empty
      end

      it 'relates saved question to user' do
        expect(assigns(:question).user).to eq subject.current_user
      end

      it 'redirects to show view for newly created question' do
        expect(response).to redirect_to(assigns(:question))
      end
    end

    context 'invalid attributes' do
      before { post :create, params: { question: attributes_for(:question, :invalid) } }

      it 'does not save a new Question in the database' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.not_to change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question, user: user) }
    
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'DELETE #destroy' do
    let(:users) { create_list(:user, 2) }

    let!(:question) { create(:question, user: users[0]) }

    context 'user is question author' do
      before { login(users[0]) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect_to index page' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'user is not question author' do
      before { login(users[1]) }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'redirect_to show page' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
