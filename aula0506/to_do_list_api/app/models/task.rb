class Task < ApplicationRecord
  validates :title, :description, :status, presence: true

  enum :status, {
    initial: "initial",
    in_progress: "in_progress",
    overdue: "overdue",
    completed: "completed",
    cancelled: "cancelled"
  }, default: :initial

end
