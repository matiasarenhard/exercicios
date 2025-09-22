class Task < ApplicationRecord
  validates :title, :description, :status, presence: true

  enum :status, { initial: 1, in_progress: 2, overdue: 3, completed: 4, cancelled: 5 }, default: :initial
end
