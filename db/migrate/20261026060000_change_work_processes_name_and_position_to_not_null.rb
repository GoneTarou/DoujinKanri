class ChangeWorkProcessesNameAndPositionToNotNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :work_processes, :name, false
    change_column_null :work_processes, :position, false
  end
end
