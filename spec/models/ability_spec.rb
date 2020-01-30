require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other_user) }

    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other_user) }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other_user) }

    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should_not be_able_to :destroy, create(:answer, user: other_user) }

    it { should be_able_to :destroy, create(:link, linkable: create(:question, user: user)) }
    it { should_not be_able_to :destroy, create(:link, linkable: create(:question, user: other_user)) }

    it { should be_able_to :best, create(:answer, user: user, question: create(:question, user: user)) }
    it { should_not be_able_to :best, create(:answer, user: user, question: create(:question, user: other_user)) }

    it { should be_able_to :comment, Question }
    it { should be_able_to :comment, Answer }

    it { should be_able_to :vote, create(:question, user: other_user) }
    it { should_not be_able_to :vote, create(:question, user: user) }

    it { should be_able_to :vote, create(:answer, user: other_user) }
    it { should_not be_able_to :vote, create(:answer, user: user) }
  end
end
