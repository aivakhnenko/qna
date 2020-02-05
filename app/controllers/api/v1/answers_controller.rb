class Api::V1::AnswersController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    @answers = Question.find(params[:question_id]).answers
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer
  end

  def create
    @answer = current_user.answers.new(answer_params.merge(question_id: params[:question_id]))
    if @answer.save
      render json: @answer, status: :created
    else
      head :forbidden
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      head :forbidden
    end
  end

  def destroy
    @answer.destroy
    head :no_content
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
