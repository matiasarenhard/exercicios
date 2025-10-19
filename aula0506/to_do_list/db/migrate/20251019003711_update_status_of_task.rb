class UpdateStatusOfTask < ActiveRecord::Migration[8.0]
 def change
    change_column :tasks, :status, :string, null: false, default: "initial"
  end
end
