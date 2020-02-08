require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions).source(:user) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe '#subscription' do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 2) }
    let!(:subscription) { create(:subscription, question: questions.first, user: user) }

    it 'returns subscription for subscribed question' do
      expect(questions.first.subscription(user)).to eq subscription
    end

    it 'returns nil for not subscribed question' do
      expect(questions.second.subscription(user)).to eq nil
    end
  end

  describe '#subscribe!' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }

    context 'not subscribed yet' do
      it 'subscribe user' do
        expect { question.subscribe!(user) }.to change(question.subscriptions, :count).by(1)
      end
    end

    context 'already subscribed' do
      let!(:subscription) { create(:subscription, user: user, question: question) }

      it 'not subscribe user' do
        expect { question.subscribe!(user) }.to_not change(question.subscriptions, :count)
      end
    end
  end

  describe '#unsubscribe!' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }

    context 'subscribed' do
      let!(:subscription) { create(:subscription, user: user, question: question) }

      it 'unsubscribe user' do
        expect { question.unsubscribe!(user) }.to change(question.subscriptions, :count).by(-1)
      end
    end

    context 'not subscribed' do
      it 'not unsubscribe user' do
        expect { question.unsubscribe!(user) }.to_not change(question.subscriptions, :count)
      end
    end
  end
end
