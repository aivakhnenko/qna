require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let(:users) { create_list(:user, 2) }
    let(:resource) { create(:question, user: users[0]) }
    let!(:link) { resource.links.last }

    context 'user is resource author' do
      before { login(users[0]) }

      it 'deletes the link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(resource.links, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'user is not resource author' do
      before { login(users[1]) }

      it 'does not delete the link' do
        expect { delete :destroy, params: { id: link }, format: :js }.not_to change(resource.links, :count)
      end

      it 'redirect_to show page for html request' do
        delete :destroy, params: { id: link }

        expect(response).to redirect_to question_path(resource)
      end

      it 'responds with status forbidden for js request' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to have_http_status :forbidden
      end
    end
  end
end
