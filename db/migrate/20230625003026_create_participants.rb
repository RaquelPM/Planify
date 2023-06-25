class CreateParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :participants do |t|
      t.references :user, index: true, null: false, foreign_key: true
      t.references :event, index: true, null: false, foreign_key: true

      t.index [:user, :event], name: 'unique_participant_per_event', unique: true

      t.timestamps
    end
  end
end
