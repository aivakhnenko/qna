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

  describe 'GET #show' do
    before { login(user) }

    let(:question) { create(:question, user: user) }
    let!(:vote) { create(:vote, votable: question, user: user, value: 1) }
    
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new Link to @answer.links' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'assigns user vote value to @vote' do
      expect(assigns(:vote)).to eq 1
    end

    it 'assigns votes result to @votes' do
      expect(assigns(:votes)).to eq 1
    end

    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns new Link to @question.links' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns new Reward to @question.reward' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'valid attributes' do
      let(:question_attributes) { attributes_for(:question) }

      before { post :create, params: { question: question_attributes } }

      it 'saves a new Question in the database' do
        expect { post :create, params: { question: question_attributes } }.to change(Question, :count).by(1)
      end

      it 'saves question with attributes from params in the database' do
        expect(question_attributes.to_a - assigns(:question).attributes.symbolize_keys.to_a).to be_empty
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

  describe 'POST #vote' do
    let(:users) { create_list(:user, 2) }
    let!(:question) { create(:question, user: users[1]) }

    context 'user is not question author' do
      before { login(users[0]) }

      context 'there is no previous vote' do
        context 'vote up' do
          it 'saves vote up in the database' do
            expect { post :vote, params: { id: question, value: 1 }, format: :json }.to change(Vote, :count).by(1)
          end

          it 'renders json of total votes sum and current user vote value' do
            post :vote, params: { id: question, value: 1 }, format: :json
            expect(response.body).to eq ({ votes: 1, vote: 1 }).to_json
          end
        end

        context 'vote down' do
          it 'saves vote up in the database' do
            expect { post :vote, params: { id: question.id, value: -1 }, format: :json }.to change(Vote, :count).by(1)
          end

          it 'renders json of total votes sum and current user vote value' do
            post :vote, params: { id: question, value: -1 }, format: :json
            expect(response.body).to eq ({ votes: -1, vote: -1 }).to_json
          end
        end
      end

      context 'there is previous vote' do
        let!(:vote) { create(:vote, votable: question, user: users[0], value: 1) }

        context 'cancel vote' do
          it 'remove vote from the database' do
            expect { post :vote, params: { id: question, value: 0 }, format: :json }.to change(Vote, :count).by(-1)
          end

          it 'renders json of total votes sum and current user vote value' do
            post :vote, params: { id: question, value: 0 }, format: :json
            expect(response.body).to eq ({ votes: 0, vote: 0 }).to_json
          end
        end

        context 'change vote' do
          it 'change vote in the database' do
            post :vote, params: { id: question, value: -1 }, format: :json
            expect(Vote.last.value).to eq -1
          end

          it 'renders json of total votes sum and current user vote value' do
            post :vote, params: { id: question, value: -1 }, format: :json
            expect(response.body).to eq ({ votes: -1, vote: -1 }).to_json
          end
        end

        context 'make the same vote' do
          it 'does not change votes in the database' do
            expect { post :vote, params: { id: question, value: 1 }, format: :json }.to_not change(Vote, :count)
          end

          it 'renders json of total votes sum and current user vote value' do
            post :vote, params: { id: question, value: 1 }, format: :json
            expect(response.body).to eq ({ votes: 1, vote: 1 }).to_json
          end
        end
      end
    end

    context 'user is question author' do
      before { login(users[1]) }

      it 'does not create vote in the database' do
        expect { post :vote, params: { id: question, value: 1 }, format: :json }.to_not change(Vote, :count)
      end

      it 'renders json of total votes sum and current user vote value' do
        post :vote, params: { id: question, value: 1 }, format: :json
        expect(response.body).to eq ({ votes: 0, vote: 0 }).to_json
      end
    end
  end

  describe 'PATCH #update' do
    let(:users) { create_list(:user, 2) }

    let!(:question) { create(:question, user: users[0]) }

    context 'user is question author' do
      before { login(users[0]) }

      context 'with valid attributes' do
        it 'changes question attributes' do
          patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
          question.reload
          expect(question.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change question attributes' do
          expect do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          end.to_not change(question, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'user is not question author' do
      before { login(users[1]) }
      let!(:body) { question.body }

      it 'does not update the question' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        question.reload

        expect(question.body).to eq body
      end

      it 'redirect_to question page' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js

        expect(response).to redirect_to question_path(question)
      end
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
