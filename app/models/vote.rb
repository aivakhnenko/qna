class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, presence: true, inclusion: { in: [-1, 1] }

  def self.result
    sum(:value)
  end
end
