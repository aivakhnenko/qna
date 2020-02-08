class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::NewAnswerNotification.new.send_notifications(answer)
  end
end
