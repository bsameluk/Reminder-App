class AddFrequencyTypeToReminder < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      ALTER TYPE reminder_frequency ADD VALUE 'Each 2 minutes';
      ALTER TYPE reminder_frequency ADD VALUE 'Each 5 minutes';
    SQL
  end

  def down
    execute <<-SQL
      CREATE TYPE new_reminder_frequency AS ENUM (
        'One-Time', 'Each day', 'Each week', 'Each month'
      );
      ALTER TABLE reminders ALTER COLUMN frequency TYPE new_reminder_frequency USING frequency::text::new_reminder_frequency;

      DROP TYPE reminder_frequency;
      ALTER TYPE new_reminder_frequency RENAME TO reminder_frequency;
    SQL
  end
end
