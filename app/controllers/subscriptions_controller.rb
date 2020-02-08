class SubscriptionsController < ApplicationController
  load_and_authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @question.subscribe!(current_user)
    redirect_to @question
  end

  def destroy
    @question = @subscription.question
    @question.unsubscribe!(current_user)
    redirect_to @question
  end
end
