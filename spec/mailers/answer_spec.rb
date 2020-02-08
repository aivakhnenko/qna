require "rails_helper"

RSpec.describe AnswerMailer, type: :mailer do
  describe "new_answer" do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:mail) { AnswerMailer.new_answer(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body with question title and new answer body" do
      expect(mail.body.encoded).to match(answer.question.title)
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
