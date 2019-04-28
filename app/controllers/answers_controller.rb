class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :find_answer, only: %i[update destroy]

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    flash.now[:notice] = 'Your answer successfully created.' if @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Your answer successfully deleted.'
    else
      redirect_to @answer.question, error: 'Only author can delete this question'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
