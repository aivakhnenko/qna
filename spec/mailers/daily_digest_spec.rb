require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:old_questions) { create_list(:question, 2, user: user, created_at: 2.days.ago) }
    let(:new_questions) { create_list(:question, 3, user: user, created_at: 1.days.ago) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body with new questions" do
      new_questions.each do |question|
        expect(mail.body.encoded).to match(question.title)
      end
    end
  end
end
