module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :comment

    after_action :publish_comment, only: :comment
  end

  def comment
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))
    @comment.save
  end
  
  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast "#{model_klass.to_s.downcase}/#{@commentable.id}/comments", @comment
  end
end
