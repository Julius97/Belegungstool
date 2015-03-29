class ChangeRemainingInLessonCard < ActiveRecord::Migration
  def change
  	change_column :lesson_cards, :remaining, :decimal
  end
end
