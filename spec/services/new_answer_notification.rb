require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:question) { create(:question) }
  let!(:subscription) { create_list(:subscription, 3, question: question) }
  let!(:answer) { create(:answer, question: question) }

  it 'sends new answer notification to subscribed users' do
    subscription.each { |s| expect(AnswerMailer).to receive(:new_answer).with(s.user).and_call_original }
    subject.send_notifications(answer)
  end
end
