class Services::NewAnswerNotification
  def send_notifications(answer)
    @users = answer.question.subscribers
    @users.find_each(batch_size: 500) do |user|
      AnswerMailer.new_answer(user).deliver_later
    end
  end
end
