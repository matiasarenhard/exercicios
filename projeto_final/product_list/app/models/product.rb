class Product < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, presence: true

  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :available, inclusion: { in: [true, false] }
end