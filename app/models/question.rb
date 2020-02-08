class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files
  has_one :reward, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation

  def subscription(user)
    subscriptions.where(user: user).first
  end

  def subscribe!(user)
    subscriptions.create(user: user) unless subscription(user)
  end

  def unsubscribe!(user)
    subscription(user)&.destroy!
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
