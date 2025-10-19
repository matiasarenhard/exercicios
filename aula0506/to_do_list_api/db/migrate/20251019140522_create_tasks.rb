class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.string :status, null: false, default: "initial"
      t.datetime :delivery_date
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
