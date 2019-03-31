class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, :user, presence: true
end
