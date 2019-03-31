class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: %i[new create destroy]
  before_action :find_answer, only: %i[show destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      redirect_to [@question, @answer], notice: 'Your answer successfully created.'
    else
      render :new
    end
  end

  def show; end

  def destroy
    if @answer.user == current_user
      @answer.destroy
      redirect_to @question, notice: 'Your answer successfully deleted.'
    else
      redirect_to @question, error: 'Only author can delete this question'
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
