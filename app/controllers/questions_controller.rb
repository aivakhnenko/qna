class QuestionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  
  before_action :find_question, only: %i[show update destroy]

  after_action :publish_question, only: :create

  include Voted
  include Commented

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.links.build
  end

  def new
    @question = Question.new
    @question.links.build
    @question.build_reward
  end

  def create
    @question = Question.new(question_params.merge(user: current_user))
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    else
      redirect_to @question, error: 'Only author can delete this question'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      redirect_to @question, error: 'Only author can delete this question'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy], reward_attributes: [:name, :image])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
    if @question
      gon.question_id = @question.id
      gon.question_user_id = @question.user_id
    end
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions', ApplicationController.render(
      partial: 'questions/question',
      locals: { question: @question }
    )
  end
end
