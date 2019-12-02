class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, presence: true

  def self.result
    sum(:value)
  end
end
