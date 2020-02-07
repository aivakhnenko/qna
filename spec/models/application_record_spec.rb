require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  describe '.created_yesterday' do
    let(:old_records) { create_list(:question, 2, created_at: 2.day.ago) }
    let(:yesterday_records) { create_list(:question, 3, created_at: 1.day.ago) }

    it { expect(Question.created_yesterday).to eq yesterday_records }
  end
end
