class AnswersController < ApplicationController
  before_action :find_question, only: %i[new create]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to [@question, @answer], notice: 'Your answer successfully created.'
    else
      render :new
    end
  end

  def show
    @answer = Answer.find(params[:id])
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
