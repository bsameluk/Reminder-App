class CreateReminders < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      CREATE TYPE reminder_frequency AS ENUM (
        'One-Time', 'Each day', 'Each week', 'Each month'
      );
    SQL

    create_table :reminders do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :scheduled_at, null: false
      t.decimal :price, precision: 14, scale: 2, null: false
      t.string :currency, limit: 3, null: false
      t.column :frequency, :reminder_frequency, null: false

      t.timestamps
    end
  end

  def down
    drop_table :reminders
    execute <<-SQL
      DROP TYPE reminder_frequency;
    SQL
  end


end
