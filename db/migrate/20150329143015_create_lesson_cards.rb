class CreateLessonCards < ActiveRecord::Migration
  def change
    create_table :lesson_cards do |t|
      t.integer :user_id
      t.integer :initially
      t.integer :remaining

      t.timestamps
    end
  end
end
