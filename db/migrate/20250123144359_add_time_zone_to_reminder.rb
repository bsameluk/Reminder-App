class AddTimeZoneToReminder < ActiveRecord::Migration[7.1]
  def change
    add_column :reminders, :timezone, :string, null: false
  end
end

