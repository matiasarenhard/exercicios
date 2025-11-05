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

  scope :overdue, -> { active.where("delivery_date < ?", Date.current).where.not(status: [:completed, :cancelled]) }

  def destroy
    update({ deleted_at: Date.today, status: Task.statuses[:cancelled] })
  end


  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "deleted_at", "delivery_date", "description", "id", "id_value", "status", "title", "updated_at"]
  end
end
