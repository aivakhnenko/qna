require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should validate_presence_of :body }
  it { should_not allow_value(nil).for(:best) }

  describe 'methods' do
    let(:users) { create_list(:user, 2) }
    let(:question) { create(:question, user: users[0]) }
    let!(:reward) { create(:reward, question: question) }
    let!(:answers) { users.map { |user| create(:answer, question: question, user: user) } }

    describe '.best_first' do
      before { answers[1].best! }

      it { expect(question.answers.best_first.ids).to eq [answers[1].id, answers[0].id] }
    end

    describe '.best' do
      before { answers[1].best! }

      it { expect(question.answers.best.ids).to eq [answers[1].id] }
    end

    describe '#best!' do
      context 'best answer is not selected' do
        it { expect { answers[0].best! }.to change(answers[0], :best).to true }
        it { expect { answers[0].best! }.to change(reward, :user).to answers[0].user }
        it { expect { answers[0].best! }.to change { answers[0].user.rewards.ids }.to [reward.id] }
      end

      context 'best answer is selected' do
        before { answers[1].best! }

        it { expect { answers[0].best! }.to change { answers[1].reload.best }.to false }
        it { expect { answers[0].best! }.to change(answers[0], :best).to true }
        it { expect { answers[0].best! }.to change(reward, :user).to answers[0].user }
        it { expect { answers[0].best! }.to change(answers[1].user.rewards, :ids).to [] }
        it { expect { answers[0].best! }.to change(answers[0].user.rewards, :ids).to [reward.id] }
      end
    end
  end
end
