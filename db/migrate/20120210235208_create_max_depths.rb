class CreateMaxDepths < ActiveRecord::Migration
  def change
    create_table :max_depths do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
