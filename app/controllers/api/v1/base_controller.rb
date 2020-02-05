class Api::V1::BaseController < ApplicationController
  skip_before_action :authenticate_user!, unless: :devise_controller?
  before_action :doorkeeper_authorize!

  private

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
