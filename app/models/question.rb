class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :votable
  has_many_attached :files
  has_one :reward, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def vote(user)
    votes.where(user: user).first&.value || 0
  end

  def vote!(user, value)
    return if user == self.user
    vote = votes.where(user: user).first
    value = value.to_i
    return unless (-1..1).include?(value)
    if vote
      if value.zero?
        vote.destroy!
      elsif value != vote.value
        vote.update!(value: value)
      end
    else
      votes.create!(user: user, value: value) if value.nonzero?
    end
  end
end
