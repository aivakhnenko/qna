require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do

  describe 'PATCH #update_email' do
    let(:user) { create(:user) }

    before { login(user) }

    context 'valid email' do
      before { patch :update_email, params: { id: user, user: { email: 'new_email@test.com' } }, format: :js }

      it 'changes user unconfirmed_email' do
        user.reload
        expect(user.unconfirmed_email).to eq 'new_email@test.com'
      end

      it 'redirects root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'invalid email' do
      it 'does not change user unconfirmed_email' do
        expect do
          patch :update_email, params: { id: user, user: { email: 'wrong_email.test.com' } }, format: :js
        end.to_not change(user, :unconfirmed_email)
      end

      it 'renders edit view' do
        patch :update_email, params: { id: user, user: { email: 'wrong_email.test.com' } }, format: :js
        expect(response).to render_template :edit_email
      end
    end
  end
end
