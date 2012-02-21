class CreateIceDiscolorations < ActiveRecord::Migration
  def change
    create_table :ice_discolorations do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
