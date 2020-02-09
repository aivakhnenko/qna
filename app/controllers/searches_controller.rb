class SearchesController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  authorize_resource class: false

  TYPES = {
    All: ThinkingSphinx, 
    Questions: Question,
    Answers: Answer,
    Comments: Comment,
    Users: User
  }.freeze

  def show
    @t = params[:t]
    @q = params[:q]
    klass = TYPES[@t.to_sym]
    @results = klass.search @q
  end
end
