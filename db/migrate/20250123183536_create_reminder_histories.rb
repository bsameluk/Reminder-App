class CreateReminderHistories < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      CREATE TYPE reminder_histories_status AS ENUM (
        'Pending', 'Done', 'Failed'
      );
    SQL

    create_table :reminder_histories do |t|
      t.references :reminder, null: false, foreign_key: true
      t.datetime :scheduled_at, null: false
      t.column :status, :reminder_histories_status, null: false, default: 'Pending'

      t.timestamps
    end
  end

  def down
    drop_table :reminder_histories
    execute <<-SQL
      DROP TYPE reminder_histories_status;
    SQL
  end
end
