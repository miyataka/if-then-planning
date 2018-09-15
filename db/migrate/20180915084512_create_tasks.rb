class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :calendar_id
      t.string :summary
      t.integer :order
      t.string :event_id

      t.timestamps
    end
  end
end
