module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

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
