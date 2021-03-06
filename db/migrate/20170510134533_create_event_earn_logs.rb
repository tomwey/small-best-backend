class CreateEventEarnLogs < ActiveRecord::Migration
  def change
    create_table :event_earn_logs do |t|
      t.references :user, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true
      t.string :uniq_id
      t.decimal :money, precision: 16, scale: 2, null: false, default: 0.0
      t.string :ip
      t.st_point :location, geographic: true

      t.timestamps null: false
    end
    add_index :event_earn_logs, :uniq_id, unique: true
    add_index :event_earn_logs, :location, using: :gist
    add_index :event_earn_logs, [:user_id, :event_id], unique: true
  end
end
