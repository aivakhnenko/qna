require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:users) { create_list(:user, 2) }
    let(:resource) { create(:question, user: users[0]) }

    context 'user' do
      context 'is an author ot the resource' do
        let(:user) { users[0] }

        it { expect(user).to be_author_of(resource) }
      end

      context 'is not an author of the resource' do
        let(:user) { users[1] }

        it { expect(user).not_to be_author_of(resource) }
      end
    end
  end
end
