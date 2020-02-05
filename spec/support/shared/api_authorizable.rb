shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request method, path
      expect(response).to have_http_status :unauthorized
    end

    it 'returns 401 status if access_token is invalid' do
      do_request method, path, params: { access_token: '1234' }
      expect(response).to have_http_status :unauthorized
    end
  end
end
