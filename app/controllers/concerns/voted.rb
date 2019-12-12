module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: :vote
  end

  def vote
    @votable.vote!(current_user, params[:value])

    respond_to do |format|
      format.json { render json: { votes: @votable.votes.result, vote: @votable.vote(current_user) } }
    end
  end
  
  private

  def set_votable
    @votable = instance_variable_get("@#{controller_name.singularize}")
  end  
end
