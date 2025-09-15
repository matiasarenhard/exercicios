class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :status, null: false
      t.datetime :delivery_date, null: true

      t.timestamps
    end
  end
end
