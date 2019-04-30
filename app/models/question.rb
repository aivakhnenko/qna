class Question < ApplicationRecord
  belongs_to :user
  belongs_to :answer, optional: true
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def answers_best_first
    return answers unless answer
    [answer] + (answers - [answer])
  end
end
