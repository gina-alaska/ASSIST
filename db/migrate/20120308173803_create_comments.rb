class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :observation_id
      t.integer :user_id
      t.text :data

      t.timestamps
    end
  end
end
