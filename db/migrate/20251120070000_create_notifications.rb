class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :message, null: false, foreign_key: true, index: { unique: true }
      t.string :preview, null: false, default: ""
      t.datetime :read_at

      t.timestamps
    end

    add_index :notifications, :read_at
    add_index :notifications, [ :user_id, :read_at ]
  end
end
