require 'rails_helper'

describe 'Answers API', type: :request do
  PUBLIC_FIELDS = %w[id body question_id user_id created_at updated_at].freeze

  let(:token) { create(:access_token).token }
  let(:question) { create(:question) }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:method) { :get }
    let(:path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answers_response) { json['answers'] }
      let(:answer) { answers.first }
      let(:answer_response) { answers_response.first }

      before { do_request method, path, params: { access_token: token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(answers_response.count).to eq answers.count
      end

      PUBLIC_FIELDS.each do |attr|
        it "returns public field #{attr}" do
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer, :with_files_attached) }
    let(:method) { :get }
    let(:path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:comments) { create_list(:comment, 3, commentable: answer) }
      let!(:links) { create_list(:link, 3, linkable: answer) }
      let(:answer_response) { json['answer'] }

      before { do_request method, path, params: { access_token: token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      PUBLIC_FIELDS.each do |attr|
        it "returns public field #{attr}" do
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comments_response) { answer_response['comments'] }

        it 'returns list of comments' do
          expect(comments_response.size).to eq answer.comments.count
        end

        %w[text user_id created_at updated_at].each do |attr|
          it "returns public field #{attr}" do
            expect(comments_response.first[attr]).to eq comments.first.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:files_response) { answer_response['files'] }
        let(:file) { answer.files.first }

        it 'returns list of files' do
          expect(files_response.size).to eq answer.files.count
        end

        %w[id filename url created_at].each do |attr|
          it "returns public field #{attr}" do
            expect(files_response.first[attr]).to eq attr == 'url' ? url_for(file) : file.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:links_response) { answer_response['links'] }

        it 'returns list of links' do
          expect(links_response.size).to eq answer.links.count
        end

        %w[name url created_at updated_at].each do |attr|
          it "returns public field #{attr}" do
            expect(links_response.first[attr]).to eq links.first.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:method) { :post }
    let(:path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'valid attributes' do
        let(:answer_attributes) { attributes_for(:answer) }
        let(:answer_response) { json['answer'] }
        let(:answer) { Answer.last }

        before { do_request method, path, params: { access_token: token, answer: answer_attributes } }

        it 'saves a new Answer in the database' do
          expect { do_request method, path, params: { access_token: token, answer: answer_attributes } }.to change(Answer, :count).by(1)
        end

        it "saves answer attributes in the database" do
          answer_attributes.each do |attr, value|
            expect(answer.send(attr)).to eq value
          end
        end

        it 'returns 201 status' do
          expect(response).to have_http_status :created
        end

        PUBLIC_FIELDS.each do |attr|
          it "returns public field #{attr}" do
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end

      context 'invalid attributes' do
        let(:answer_attributes) { attributes_for(:answer, :invalid) }

        before { do_request method, path, params: { access_token: token, answer: answer_attributes } }

        it 'does not save a new Answer in the database' do
          expect { do_request method, path, params: { access_token: token, answer: answer_attributes } }.not_to change(Answer, :count)
        end

        it 'returns 422 status' do
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:author) { create(:user) }
    let!(:answer) { create(:answer, user: author) }
    let(:method) { :patch }
    let(:path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'user is answer author' do
        let(:token) { create(:access_token, resource_owner_id: author.id).token }

        context 'valid attributes' do
          let(:answer_attributes) { { body: 'NewBody' } }
          let(:answer_response) { json['answer'] }

          before { do_request method, path, params: { access_token: token, id: answer, answer: answer_attributes } }

          it "saves answer attributes in the database" do
            answer_attributes.each do |attr, value|
              expect(answer.reload.send(attr)).to eq value
            end
          end

          it 'returns 200 status' do
            expect(response).to have_http_status :ok
          end

          PUBLIC_FIELDS.each do |attr|
            it "returns public field #{attr}" do
              expect(answer_response[attr]).to eq answer.reload.send(attr).as_json
            end
          end
        end

        context 'invalid attributes' do
          let(:answer_attributes) { attributes_for(:answer, :invalid) }

          it "does not change answer attributes in the database" do
            answer_attributes.each_key do |attr|
              expect do
                do_request method, path, params: { access_token: token, answer: answer_attributes }
              end.to_not change(answer, attr.to_sym)
            end
          end

          it 'returns 422 status' do
            do_request method, path, params: { access_token: token, answer: answer_attributes }
            expect(response).to have_http_status :unprocessable_entity
          end
        end
      end

      context 'user is not answer author' do
        let(:other_user) { create(:user) }
        let(:token) { create(:access_token, resource_owner_id: other_user.id).token }
        let(:answer_attributes) { { body: 'NewBody' } }

        it "does not change answer attributes in the database" do
          answer_attributes.each_key do |attr|
            expect do
              do_request method, path, params: { access_token: token, answer: answer_attributes }
            end.to_not change(answer, attr.to_sym)
          end
        end

        it 'returns 403 status' do
          do_request method, path, params: { access_token: token, answer: answer_attributes }
          expect(response).to have_http_status :forbidden
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:author) { create(:user) }
    let!(:answer) { create(:answer, user: author) }
    let(:method) { :delete }
    let(:path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'user is answer author' do
        let(:token) { create(:access_token, resource_owner_id: author.id).token }

        it "deletes the answer" do
          expect { do_request method, path, params: { access_token: token, id: answer } }.to change(Answer, :count).by(-1)
        end

        it 'returns 204 status' do
          do_request method, path, params: { access_token: token, id: answer }
          expect(response).to have_http_status :no_content
        end
      end

      context 'user is not answer author' do
        let(:other_user) { create(:user) }
        let(:token) { create(:access_token, resource_owner_id: other_user.id).token }

        it "does not delete the answer" do
          expect { do_request method, path, params: { access_token: token, id: answer } }.to_not change(Answer, :count)
        end

        it 'returns 403 status' do
          do_request method, path, params: { access_token: token, id: answer }
          expect(response).to have_http_status :forbidden
        end
      end
    end
  end
end
