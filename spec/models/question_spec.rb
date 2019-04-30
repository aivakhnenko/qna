require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should belong_to(:answer).optional }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '.answers_best_first' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answers) { create_list(:answer, 2, question: question, user: user) }

    context 'best answer is not selected' do
      it { expect(question.answers_best_first).to eq [answers[0], answers[1]] }
    end

    context 'best answer is selected' do
      before { question.update(answer: answers[1]) }

      it { expect(question.answers_best_first).to eq [answers[1], answers[0]] }
    end
  end
end
