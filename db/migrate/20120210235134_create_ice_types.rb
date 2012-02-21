class CreateIceTypes < ActiveRecord::Migration
  def change
    create_table :ice_types do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
