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

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
