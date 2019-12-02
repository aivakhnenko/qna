require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  it { should validate_presence_of :value }

  describe '.result' do
    let(:users) { create_list(:user, 2) }
    let(:question) { create(:question, user: users[0]) }
    let!(:vote) { create(:vote, votable: question, user: users[1], value: 1) }

    it { expect(question.votes.result).to eq 1 }
  end
end
