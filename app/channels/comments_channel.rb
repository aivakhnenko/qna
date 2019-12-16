class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from data['stream']
  end
end
