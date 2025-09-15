class Task < ApplicationRecord
  validates :title, :description, :status, presence: true
end
