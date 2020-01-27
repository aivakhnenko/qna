module Services
  class FindForOauth
    attr_reader :auth

    def initialize(auth)
      @auth = auth
    end

    def call
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization
      email = (auth.info && auth.info[:email]) ? auth.info[:email] : "omniauth_tmp_#{Devise.friendly_token[0, 20]}@omniauth_tmp.tmp"
      user = User.where(email: email).first
      unless user
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password, confirmed_at: Time.now.utc)
      end
      user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
      user
    end
  end
end
