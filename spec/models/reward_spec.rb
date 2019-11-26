require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).optional }

  it 'has one attached image' do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  it { should validate_presence_of :name }

  context 'without image' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it { expect(Reward.new(name: 'Prize', question: question)).to_not be_valid }
  end
end
