require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:users) { create_list(:user, 2) }
    let(:question) { create(:question, user: users[0]) }
    let(:answer) { create(:answer, question: question, user: users[0]) }

    context 'user' do
      context 'is an author' do
        let(:user) { users[0] }

        context 'of the question' do
          it { expect(user.author_of?(question)).to be_truthy }
        end

        context 'of the answer' do
          it { expect(user.author_of?(answer)).to be_truthy }
        end
      end

      context 'is not an author' do
        let(:user) { users[1] }

        context 'of the question' do
          it { expect(user.author_of?(question)).to be_falsey }
        end

        context 'of the answer' do
          it { expect(user.author_of?(answer)).to be_falsey }
        end
      end
    end
  end
end
