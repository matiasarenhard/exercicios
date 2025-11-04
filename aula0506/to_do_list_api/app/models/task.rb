class Task < ApplicationRecord
  validates :title, :description, :status, presence: true

  enum :status, {
    initial: "initial",
    in_progress: "in_progress",
    overdue: "overdue",
    completed: "completed",
    cancelled: "cancelled"
  }, default: :initial

  scope :active, -> { where(deleted_at: nil) }

  scope :inactive, -> { where.not(deleted_at: nil) }

  def destroy
    update({ deleted_at: Date.today, status: Task.statuses[:cancelled] })
  end
end
