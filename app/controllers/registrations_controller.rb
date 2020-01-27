class RegistrationsController < Devise::RegistrationsController
  def update_email
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to root_path
    else
      render 'devise/registrations/edit_email'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
