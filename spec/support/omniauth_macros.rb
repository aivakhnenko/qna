module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '123545',
      'info' => {
        'email' => 'user1@test.com'
      }
    })
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      'provider' => 'twitter',
      'uid' => '123545'
    })
  end
end
