require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:answer) { create(:answer) }
  let(:service) { double(Services::NewAnswerNotification) }

  before do
    allow(Services::NewAnswerNotification).to receive(:new).and_return(service)
  end

  it 'calls Services::NewAnswerNotification#send_notification' do
    expect(service).to receive(:send_notifications).with(answer)
    NewAnswerJob.perform_now(answer)
  end
end
