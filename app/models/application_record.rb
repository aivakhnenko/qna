class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :created_yesterday, -> { where(created_at: (Time.current.prev_day.beginning_of_day..Time.current.prev_day.end_of_day)) }
end
