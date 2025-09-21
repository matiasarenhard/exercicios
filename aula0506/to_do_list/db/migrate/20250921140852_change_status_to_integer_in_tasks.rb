class ChangeStatusToIntegerInTasks < ActiveRecord::Migration[8.0]
  def change
    change_column :tasks, :status, :integer, using: 'status::integer', default: 1, null: false
  end
end