class AddStatusCanceledToReminderHistory < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      ALTER TYPE reminder_histories_status ADD VALUE 'Canceled';
    SQL
  end

  def down
    execute <<-SQL
      CREATE TYPE reminder_histories_status_new AS ENUM (
        'Pending', 'Done', 'Failed'
      );
      ALTER TABLE reminder_histories ALTER COLUMN status TYPE reminder_histories_status_new USING status::text::reminder_histories_status_new;

      DROP TYPE reminder_histories_status;
      ALTER TYPE reminder_histories_status_new RENAME TO reminder_histories_status;
    SQL
  end
end
