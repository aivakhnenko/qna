class AnswersController < ApplicationController
  before_action :find_question, only: :create
  before_action :find_answer, only: %i[show update destroy]

  after_action :publish_answer, only: :create

  include Voted

  def show
    redirect_to @answer.question
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    flash.now[:notice] = 'Your answer successfully created.' if @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    else
      redirect_to @answer.question, error: 'Only author can edit this answer'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @question = @answer.question
      @answer.destroy
      flash.now[:notice] = 'Your answer successfully deleted.'
    else
      redirect_to @answer.question, error: 'Only author can delete this answer'
    end
  end

  def best
    @answer = Answer.find(params[:answer_id])
    @question = @answer.question
    if current_user.author_of?(@question)
      @answer.best!
    else
      redirect_to @question
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
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
