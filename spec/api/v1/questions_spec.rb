require 'rails_helper'

describe 'Questions API', type: :request do
  PUBLIC_FIELDS = %w[id title body user_id created_at updated_at].freeze

  let(:token) { create(:access_token).token }

  describe 'GET /api/v1/questions' do
    let(:method) { :get }
    let(:path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:questions_response) { json['questions'] }
      let(:question) { questions.first }
      let(:question_response) { questions_response.first }

      before { do_request method, path, params: { access_token: token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(questions_response.count).to eq questions.count
      end

      PUBLIC_FIELDS.each do |attr|
        it "returns public field #{attr}" do
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question, :with_files_attached) }
    let(:method) { :get }
    let(:path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      let(:question_response) { json['question'] }

      before { do_request method, path, params: { access_token: token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      PUBLIC_FIELDS.each do |attr|
        it "returns public field #{attr}" do
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comments_response) { question_response['comments'] }

        it 'returns list of comments' do
          expect(comments_response.size).to eq question.comments.count
        end

        %w[text user_id created_at updated_at].each do |attr|
          it "returns public field #{attr}" do
            expect(comments_response.first[attr]).to eq comments.first.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:files_response) { question_response['files'] }
        let(:file) { question.files.first }

        it 'returns list of files' do
          expect(files_response.size).to eq question.files.count
        end

        %w[id filename url created_at].each do |attr|
          it "returns public field #{attr}" do
            expect(files_response.first[attr]).to eq attr == 'url' ? url_for(file) : file.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:links_response) { question_response['links'] }

        it 'returns list of links' do
          expect(links_response.size).to eq question.links.count
        end

        %w[name url created_at updated_at].each do |attr|
          it "returns public field #{attr}" do
            expect(links_response.first[attr]).to eq links.first.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:method) { :post }
    let(:path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'valid attributes' do
        let(:question_attributes) { attributes_for(:question) }
        let(:question_response) { json['question'] }
        let(:question) { Question.last }

        before { do_request method, path, params: { access_token: token, question: question_attributes } }

        it 'saves a new Question in the database' do
          expect { do_request method, path, params: { access_token: token, question: question_attributes } }.to change(Question, :count).by(1)
        end

        it "saves question attributes in the database" do
          question_attributes.each do |attr, value|
            expect(question.send(attr)).to eq value
          end
        end

        it 'returns 201 status' do
          expect(response).to have_http_status :created
        end

        PUBLIC_FIELDS.each do |attr|
          it "returns public field #{attr}" do
            expect(question_response[attr]).to eq question.send(attr).as_json
          end
        end
      end

      context 'invalid attributes' do
        let(:question_attributes) { attributes_for(:question, :invalid) }

        before { do_request method, path, params: { access_token: token, question: question_attributes } }

        it 'does not save a new Question in the database' do
          expect { do_request method, path, params: { access_token: token, question: question_attributes } }.not_to change(Question, :count)
        end

        it 'returns 422 status' do
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:author) { create(:user) }
    let!(:question) { create(:question, user: author) }
    let(:method) { :patch }
    let(:path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'user is question author' do
        let(:token) { create(:access_token, resource_owner_id: author.id).token }

        context 'valid attributes' do
          let(:question_attributes) { { title: 'NewTitle' } }
          let(:question_response) { json['question'] }

          before { do_request method, path, params: { access_token: token, id: question, question: question_attributes } }

          it "saves question attributes in the database" do
            question_attributes.each do |attr, value|
              expect(question.reload.send(attr)).to eq value
            end
          end

          it 'returns 200 status' do
            expect(response).to have_http_status :ok
          end

          PUBLIC_FIELDS.each do |attr|
            it "returns public field #{attr}" do
              expect(question_response[attr]).to eq question.reload.send(attr).as_json
            end
          end
        end

        context 'invalid attributes' do
          let(:question_attributes) { attributes_for(:question, :invalid) }

          it "does not change question attributes in the database" do
            question_attributes.each_key do |attr|
              expect do
                do_request method, path, params: { access_token: token, question: question_attributes }
              end.to_not change(question, attr.to_sym)
            end
          end

          it 'returns 422 status' do
            do_request method, path, params: { access_token: token, question: question_attributes }
            expect(response).to have_http_status :unprocessable_entity
          end
        end
      end

      context 'user is not question author' do
        let(:other_user) { create(:user) }
        let(:token) { create(:access_token, resource_owner_id: other_user.id).token }
        let(:question_attributes) { { title: 'NewTitle' } }

        it "does not change question attributes in the database" do
          question_attributes.each_key do |attr|
            expect do
              do_request method, path, params: { access_token: token, question: question_attributes }
            end.to_not change(question, attr.to_sym)
          end
        end

        it 'returns 403 status' do
          do_request method, path, params: { access_token: token, question: question_attributes }
          expect(response).to have_http_status :forbidden
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:author) { create(:user) }
    let!(:question) { create(:question, user: author) }
    let(:method) { :delete }
    let(:path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'user is question author' do
        let(:token) { create(:access_token, resource_owner_id: author.id).token }

        it "deletes the question" do
          expect { do_request method, path, params: { access_token: token, id: question } }.to change(Question, :count).by(-1)
        end

        it 'returns 204 status' do
          do_request method, path, params: { access_token: token, id: question }
          expect(response).to have_http_status :no_content
        end
      end

      context 'user is not question author' do
        let(:other_user) { create(:user) }
        let(:token) { create(:access_token, resource_owner_id: other_user.id).token }

        it "does not delete the question" do
          expect { do_request method, path, params: { access_token: token, id: question } }.to_not change(Question, :count)
        end

        it 'returns 403 status' do
          do_request method, path, params: { access_token: token, id: question }
          expect(response).to have_http_status :forbidden
        end
      end
    end
  end
end
