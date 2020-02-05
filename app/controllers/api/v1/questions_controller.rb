class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      render json: @question, status: :created
    else
      head :forbidden
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      head :forbidden
    end
  end

  def destroy
    @question.destroy
    head :no_content
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
