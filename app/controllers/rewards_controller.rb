class RewardsController < ApplicationController
  authorize_resource

  def index
    @rewards = current_user.rewards
  end
end
