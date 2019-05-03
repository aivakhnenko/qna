class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  has_many_attached :files

  validates :body, presence: true
  validates :best, inclusion: [true, false]

  scope :best_first, -> { order(best: :desc) }

  def best!
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
