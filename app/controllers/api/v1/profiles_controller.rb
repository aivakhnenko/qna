class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_resource_owner
  end

  def index
    @other_users = User.all.where.not(id: current_resource_owner.id)
    render json: @other_users
  end
end
