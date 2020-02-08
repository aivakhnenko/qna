class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :user
  belongs_to :question
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true
  validates :best, inclusion: [true, false]

  scope :best_first, -> { order(best: :desc) }
  scope :best, -> { where(best: true) }

  after_create :new_answer_notification

  def best!
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
      question.reward.update!(user: user) if question.reward
    end
  end

  private

  def new_answer_notification
    NewAnswerJob.perform_later(self)
  end
end
