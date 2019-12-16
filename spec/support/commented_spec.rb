require 'rails_helper'

shared_examples 'commented' do
  let(:model) { described_class.controller_name.singularize }

  describe 'POST #comment' do
    let(:user) { create(:user) }
    let!(:resource) { create(model, user: user) }

    before { login(user) }

    context 'valid attributes' do
      let(:comment_attributes) { { text: 'Comment text' } }

      before { post :comment, params: { id: resource, comment: comment_attributes }, format: :js }

      it 'saves comment in the database' do
        expect { post :comment, params: { id: resource, comment: comment_attributes }, format: :js }.to change(Comment, :count).by(1)
      end

      it 'saves comment with attributes from params in the database' do
        expect(comment_attributes.to_a - assigns(:comment).attributes.symbolize_keys.to_a).to be_empty
      end

      it 'renders comment view' do
        expect(response).to render_template :comment
      end
    end

    context 'invalid attributes' do
      it 'does not save comment in the database' do
        expect { post :comment, params: { id: resource, comment: { text: nil } }, format: :js }.not_to change(Comment, :count)
      end

      it 'renders comment view' do
        post :comment, params: { id: resource, comment: { text: nil } }, format: :js

        expect(response).to render_template :comment
      end
    end
  end
end
