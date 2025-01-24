class AddJobIdToReminderHistory < ActiveRecord::Migration[7.1]
  def change
    add_column :reminder_histories, :job_id, :string
  end
end

