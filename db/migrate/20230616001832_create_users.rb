class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :user_name, null: false, index: { unique: true }
      t.string :email, null: false, index: { unique: true }
      t.string :password, null: false
      t.string :phone
      t.text :description
      t.string :avatar_url

      t.timestamps
    end
  end
end
