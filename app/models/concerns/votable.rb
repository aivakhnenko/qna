module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user)
    votes.where(user: user).first&.value || 0
  end

  def vote!(user, value)
    return if user.id == self.user.id
    vote = votes.where(user: user).first
    value = value.to_i
    if vote
      if value.zero?
        vote.destroy!
      elsif value != vote.value
        vote.update(value: value)
      end
    else
      votes.create(user: user, value: value)
    end
  end
end
