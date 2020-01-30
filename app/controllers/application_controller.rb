class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?

  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to cancan_redirect_path(exception), alert: exception.message
  end

  check_authorization unless: :devise_controller?

  private

  def gon_user
    gon.current_user_id = current_user.id if current_user
  end

  def cancan_redirect_path(exception)
    case exception.subject
    when Question
      @question
    when Answer
      @answer.question
    when Link
      @link.linkable
    else
      root_path
    end
  end
end
