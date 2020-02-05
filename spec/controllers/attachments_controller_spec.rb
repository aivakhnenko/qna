require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:users) { create_list(:user, 2) }
    let(:resource) { create(:question, :with_file_attached, user: users[0]) }
    let!(:file) { resource.files.last }

    context 'user is resource author' do
      before { login(users[0]) }

      it 'deletes the file' do
        expect { delete :destroy, params: { id: file }, format: :js }.to change(resource.files, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: file }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'user is not resource author' do
      before { login(users[1]) }

      it 'does not delete the file' do
        expect { delete :destroy, params: { id: file }, format: :js }.not_to change(resource.files, :count)
      end

      it 'redirect_to show page for html request' do
        delete :destroy, params: { id: file }

        expect(response).to redirect_to question_path(resource)
      end

      it 'responds with status unauthorized for js request' do
        delete :destroy, params: { id: file }, format: :js

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
