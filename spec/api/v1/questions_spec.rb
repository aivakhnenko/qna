require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:public_fields) { %w[id title body user_id created_at updated_at] }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:questions_response) { json['questions'] }
      let(:question) { questions.first }
      let(:question_response) { questions_response.first }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(questions_response.size).to eq 2
      end

      it 'returns all public fields' do
        public_fields.each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions/1' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question, :with_files_attached) }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      let(:question_response) { json['question'] }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comments_response) { question_response['comments'] }

        it 'returns list of comments' do
          expect(comments_response.size).to eq question.comments.count
        end

        it 'returns all public fields' do
          %w[text user_id created_at updated_at].each do |attr|
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

        it 'returns all public fields' do
          %w[id filename url created_at].each do |attr|
            expect(files_response.first[attr]).to eq attr == 'url' ? url_for(file) : file.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:links_response) { question_response['links'] }

        it 'returns list of links' do
          expect(links_response.size).to eq question.links.count
        end

        it 'returns all public fields' do
          %w[name url created_at updated_at].each do |attr|
            expect(links_response.first[attr]).to eq links.first.send(attr).as_json
          end
        end
      end

# список прикрепленных ссылок
    end
  end
end
