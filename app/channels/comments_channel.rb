class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from params[:stream]
  end
end
