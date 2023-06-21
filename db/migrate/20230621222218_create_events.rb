class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.text :description
      t.datetime :start_date, null: false
      t.datetime :finish_date
      t.string :place, null: false
      t.boolean :is_public, default: false
      t.references :creator, index: true, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
