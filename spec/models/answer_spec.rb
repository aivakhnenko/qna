require 'rails_helper'

RSpec.describe Answer, type: :model do
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
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answers) { create_list(:answer, 2, question: question, user: user) }

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
        it { expect { answers[0].best! }.to change(answers[0], :best).to(true) }
      end

      context 'best answer is selected' do
        before { answers[1].best! }

        it { expect { answers[0].best! }.to change { answers[1].reload.best }.to(false) }
        it { expect { answers[0].best! }.to change(answers[0], :best).to(true) }
      end
    end
  end
end
