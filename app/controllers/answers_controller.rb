class AnswersController < ApplicationController
  before_action :find_answer, only: %i[show update destroy best]
  before_action :find_question, only: %i[create update best]

  after_action :publish_answer, only: :create

  include Voted
  include Commented

  authorize_resource

  def show
    redirect_to @answer.question
  end

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    flash.now[:notice] = 'Your answer successfully created.' if @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
    flash.now[:notice] = 'Your answer successfully deleted.'
  end

  def best
    authorize! :best, @answer
    @answer.best!
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:answer_id] || params[:id])
  end

  def find_question
    @question = params[:question_id] ? Question.find(params[:question_id]) : @answer.question
  end

  def publish_answer
    return if @answer.errors.any?
    partial = ApplicationController.render(
        partial: 'answers/answer',
        locals: { answer: @answer, action_cable: true }
      )
    ActionCable.server.broadcast "questions/#{@question.id}/answers", {
      partial: partial,
      answer_user_id: @answer.user_id
    }
  end
end
