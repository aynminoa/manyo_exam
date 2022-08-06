class ChangeDatatypeDeadlineOfTasks < ActiveRecord::Migration[6.1]
  def change
    change_column :tasks, :deadline, :date
  end
end
