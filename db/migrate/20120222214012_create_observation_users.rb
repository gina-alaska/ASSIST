class CreateObservationUsers < ActiveRecord::Migration
  def change
    create_table :observation_users do |t|
      t.integer :observation_id
      t.integer :user_id
      t.boolean :primary

      t.timestamps
    end
  end
end
