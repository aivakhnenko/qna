class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = Services::FindForOauth.new(request.env['omniauth.auth']).call

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
