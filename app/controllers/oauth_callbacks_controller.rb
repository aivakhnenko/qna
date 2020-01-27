class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    default_processing
  end

  def facebook
    default_processing
  end

  private

  def default_processing
    @user = Services::FindForOauth.new(request.env['omniauth.auth']).call
puts @user.email if @user

    if @user&.persisted?
      if @user.email =~ /omniauth_tmp_.*@omniauth_tmp.tmp/
puts '1'
        render 'devise/registrations/edit_email'
      else
puts '2'
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
      end
    else
puts '3'
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
