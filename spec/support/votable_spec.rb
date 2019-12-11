require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:users) { create_list(:user, 2) }
  let(:resource) { create(described_class.to_s.underscore.to_sym, user: users[0]) }

  describe '#vote' do
    let!(:vote) { create(:vote, votable: resource, user: users[1], value: 1) }

    context 'there is vote for user' do
      it { expect(resource.vote(users[1])).to eq 1 }
    end

    context 'there is not vote for user' do
      it { expect(resource.vote(users[0])).to eq 0 }
    end
  end

  describe '#vote!' do
    context 'user is resource author' do
      it { expect { resource.vote!(users[0], 1) }.to_not change(Vote, :count) }
    end

    context 'user is not resource author' do
      context 'there is no vote for user' do
        context 'integer value' do
          it { expect { resource.vote!(users[1], 1) }.to change(Vote, :count).by(1) }
        end

        context 'string value' do
          it { expect { resource.vote!(users[1], '1') }.to change(Vote, :count).by(1) }
        end

        context 'wrong value' do
          it { expect { resource.vote!(users[1], 2) }.to_not change(Vote, :count) }
        end
      end

      context 'there is vote for user' do
        let!(:vote) { create(:vote, votable: resource, user: users[1], value: 1) }

        context 'vote the same vote' do
          it { expect { resource.vote!(users[1], 1) }.to_not change(Vote.last, :value) }
        end

        context 'vote different vote' do
          before { resource.vote!(users[1], -1) }
          
          it { expect(Vote.last.value).to eq -1 }
        end

        context 'cancel vote' do
          it { expect { resource.vote!(users[1], 0) }.to change(Vote, :count).by(-1) }
        end
      end
    end
  end
end
