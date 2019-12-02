require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '#vote' do
    let(:users) { create_list(:user, 2) }
    let(:question) { create(:question, user: users[0]) }
    let!(:vote) { create(:vote, votable: question, user: users[1], value: 1) }

    context 'there is vote for user' do
      it { expect(question.vote(users[1])).to eq 1 }
    end

    context 'there is not vote for user' do
      it { expect(question.vote(users[0])).to eq 0 }
    end
  end

  describe '#vote!' do
    let(:users) { create_list(:user, 2) }
    let!(:question) { create(:question, user: users[0]) }

    context 'user is question author' do
      it { expect { question.vote!(users[0], 1) }.to_not change(Vote, :count) }
    end

    context 'user is not question author' do
      context 'there is no vote for user' do
        context 'integer value' do
          it { expect { question.vote!(users[1], 1) }.to change(Vote, :count).by(1) }
        end

        context 'string value' do
          it { expect { question.vote!(users[1], '1') }.to change(Vote, :count).by(1) }
        end

        context 'wrong value' do
          it { expect { question.vote!(users[1], 2) }.to_not change(Vote, :count) }
        end
      end

      context 'there is vote for user' do
        let!(:vote) { create(:vote, votable: question, user: users[1], value: 1) }

        context 'vote the same vote' do
          it { expect { question.vote!(users[1], 1) }.to_not change(Vote.last, :value) }
        end

        context 'vote different vote' do
          before { question.vote!(users[1], -1) }
          
          it { expect(Vote.last.value).to eq -1 }
        end

        context 'cancel vote' do
          it { expect { question.vote!(users[1], 0) }.to change(Vote, :count).by(-1) }
        end
      end
    end
  end
end
