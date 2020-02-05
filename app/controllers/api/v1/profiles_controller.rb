class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource :user

  def me
    render json: current_user
  end

  def index
    @other_users = User.all.where.not(id: current_user.id)
    render json: @other_users
  end
end
